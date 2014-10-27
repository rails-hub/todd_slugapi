class ShotController < ApiController
  skip_before_filter :verify_authenticity_token

  def get_shots_api
    challenge_details = Hash.new []
    @shots = @logged_user.shots
    array = []
    @friends = Friendship.where('(user_id=? OR friend_id=?) AND accepted=?', @logged_user.id, @logged_user.id, true)
    @friends.each do |f|
      who_id = f.user_id == @logged_user.id ? f.friend_id : f.user_id
      user = User.find_by_id(who_id)
      array.push(user.shots)
    end
    challenge_details["user_shots"] = @shots
    challenge_details["friends_shots"] = array
    json challenge_details
  end

  def post_shot_api
    @shot = Shot.new(:caption => shot_params[:caption], :s3url => shot_params[:s3url], :user_id => @logged_user.id)
    @shot.save()
    @user_challenges = Challenge.where('(challengee_id = ? OR challenger_id = ?) AND accepted = ?', @logged_user.id, @logged_user.id, true)
    array = []
    if !@user_challenges.blank?
      challenge_details = Hash.new []
      @user_challenges.each do |challenge|
        challenge_shot = Challenge_Shot.new(:challenge_id => challenge.id, :shot_id => @shot.id, :user_id => @logged_user.id)
        challenge_shot.save()
        challenge_hash = {}
        challenge_hash["challenge"] = challenge
        cShots = Challenge_Shot.where('user_id = ? AND challenge_id = ?', @logged_user.id, challenge.id)
        challenge_hash["shots_count"] = cShots.count
        array.push(challenge_hash)

        #who is to send push notification
        user_id = @logged_user.id == challenge.challengee_id ? challenge.challenger_id : challenge.challengee_id
        user = User.find_by_id(user_id)
        PushController.push_message_to_user "#{@logged_user.username} has uploaded a Bug shot against the challenge. His Bug shot count is #{cShots.count}", user

        if cShots.count >= 15
          PushController.push_message_to_user "#{@logged_user.username} has won the challenge by uploading 15 Bug shots before you.", user
          PushController.push_message_to_user "You have won the challenge against #{user.username} by uploading 15 Bug shots before him.", user
        end
      end
      challenge_details["challenge_shots"] = array
      json challenge_details
    else
      success "Shot Uploaded Successfully"
    end

  end

  def delete_shot_api
    shot = Shot.find_by_id_and_user_id(delete_shot_params[:shot_id], @logged_user.id)
    unless shot.blank?
      begin
        challenge_shot = Challenge_Shot.where('user_id = ? AND shot_id = ?', @logged_user.id, shot.id)
        challenge_shot.each do |cs|
          challenge = Challenge.find_by_id(cs.challenge_id)
          user_id = @logged_user.id == challenge.challengee_id ? challenge.challenger_id : challenge.challengee_id
          user = User.find_by_id(user_id)
          cs.destroy!
          cShots = Challenge_Shot.where('user_id = ? AND challenge_id = ?', @logged_user.id, challenge.id)
          PushController.push_message_to_user "#{@logged_user.username} has deleted a Bug shot against the challenge. His Bug shot count is #{cShots.count}", user
        end
        shot.destroy!
        success "Shot Deleted Successfully."
      rescue Exception => exc
        error "Something went wrong."
      end
    else
      error "No such shot found."
    end
  end

  def shot_params
    params.permit(:caption, :s3url)
  end

  def delete_shot_params
    params.permit(:auth_token, :shot_id)
  end

end
