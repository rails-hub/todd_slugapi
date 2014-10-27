class Friendship < ActiveRecord::Base
  validates_presence_of :user_id, :friend_id
  #self.primary_key = [:user_id, :friend_id]

  belongs_to :user, :class_name=>"User", :foreign_key=>"user_id"
  belongs_to :friend, :class_name=>"User", :foreign_key=>"friend_id"
end
