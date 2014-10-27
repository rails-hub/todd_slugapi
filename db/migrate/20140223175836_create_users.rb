class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :phone
      t.boolean :has_challenge_mode, :default => false
      t.boolean :has_sharing, :default => false
      t.string :username, :null => false, :default => ""
      t.string :auth_token

      t.timestamps
    end
  end
end
