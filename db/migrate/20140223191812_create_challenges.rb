class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.integer :challenger_id
      t.integer :challengee_id
      t.boolean :accepted, :default => false

      t.timestamps
    end

    add_index :challenges, [:challenger_id, :challengee_id], :unique => true
  end
end
