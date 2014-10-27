class CreateChallengeShots < ActiveRecord::Migration
  def change
    create_table :challenge_shots do |t|
      t.references :challenge
      t.references :shot
      t.references :user

      t.timestamps
    end

  end
end
