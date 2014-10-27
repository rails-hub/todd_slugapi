class Challenge < ActiveRecord::Base
  has_many :shots
  validates_presence_of :challengee_id, :challenger_id
  #self.primary_key = [:challenger_id, :challengee_id]

  belongs_to :challengee, :class_name=>"User", :foreign_key=>"challengee_id"
  belongs_to :challenger, :class_name=>"User", :foreign_key=>"challenger_id"

  has_many :challenge_shots
end
