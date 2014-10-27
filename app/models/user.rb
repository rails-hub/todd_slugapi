class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :generate_auth_token
  before_save :downcase_identifiers

  has_many :friends, :class_name => "Friendship", :foreign_key => "user_id", :dependent => :destroy
  has_many :challenges, :foreign_key => "challenger_id", :dependent => :destroy
  has_many :challenge_shots, :dependent => :destroy

  #validates :password, presence: true, length: {minimum: 5, maximum: 120}, on: :create
  #validates :password, length: {minimum: 5, maximum: 120}, on: :update, allow_blank: true

  #has_many :occurances_as_challenge, :class_name => "Challenge", :foreign_key => "challengee_id", :dependent => :destroy

  def challenges
    Challenge.where('challenger_id=? OR challengee_id=?', id, id)
  end

  def friends
    #friends of mine (only those who have accepted my friend request)
    whole_friends = Hash.new []
    friends = Hash.new []
    my_friends = Friendship.where('(user_id=? OR friend_id=?) AND accepted=?', id, id, true)
    friends_list = Array.new
    my_friends.each do |fs|
      this_friend = nil
      if (fs.user_id==self.id)
        # This is this user, the other person is the friend
        this_friend = User.find_by_id(fs.friend_id)
      else
        # This is the other user
        this_friend = User.find_by_id(fs.user_id)
      end
      # Clear auth information
      this_friend.auth_token = nil
      friends_list << this_friend
    end
    friends["friends"] = friends_list
    my_f = Friendship.where('friend_id=? AND accepted=?', id, false)
    friends_l = Array.new
    my_f.each do |fs|
      this_friend = nil
      this_friend = User.find_by_id(fs.user_id)
      this_friend.auth_token = nil
      friends_l << this_friend
    end
    friends["pending"] = friends_l
    whole_friends["total_friends"] = friends
    whole_friends
  end

  def pending_friends
    #friends of mine who have added me as a friend (only those where request is pending)
    my_friends = Friendship.where('friend_id=? AND accepted=?', id, false)
    friends_list = Array.new
    my_friends.each do |fs|
      this_friend = nil
      this_friend = User.find_by_id(fs.user_id)
      this_friend.auth_token = nil
      friends_list << this_friend
    end
    friends_list
  end

  has_many :shots

  validates_presence_of :username, :password

  def email_required?
    false
  end

  def invite_friend (friend)
    f = Friendship.new(:user_id => self.id, :friend_id => friend.id)
    begin
      f.save!
    rescue
      return false
    end
    if !f.nil?
      PushController.push_message_to_user "#{username} has invited you to be friends on Slug Buggy", friend
      true
    else
      false
    end
  end

  def challenge (challengee)
    puts 'Create challenge object'
    challenge = Challenge.new(:challenger_id => self.id, :challengee_id => challengee.id)
    begin
      challenge.save!
    rescue
      return false
    end

    if !challenge.nil?
      puts 'Send push'
      PushController.push_message_to_user "#{username} has challenged you to a new game on Slug Buggy", challengee
      puts "#{username} has challenged you to a new game"
      return true
    else
      return false
    end
  end

  def set_defaults
    puts 'Set_defaults'
    has_challenge_mode = false
    has_sharing = false
    save!
  end

  def downcase_identifiers
    self.username.downcase! if self.username
    self.email.downcase! if self.email
  end

  def generate_auth_token
    puts 'generate_auth_token'
    # TODO: Remove this line and the if false below to generate real tokens
    #self.auth_token = "aa8xsYyUX1KTXRDQbdUeuk"
    #self.save
    tmp_auth_token = nil
    loop do
      tmp_auth_token = Devise.friendly_token
      break if User.where(:auth_token => tmp_auth_token).count==0
    end
    self.update_attribute('auth_token', tmp_auth_token)
  end

end
