class Shot < ActiveRecord::Base
  belongs_to :user

  has_many :challenge_shots
end
