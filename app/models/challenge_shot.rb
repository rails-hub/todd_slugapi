class Challenge_Shot < ActiveRecord::Base
  belongs_to :shot
  belongs_to :challenge
  belongs_to :user
end