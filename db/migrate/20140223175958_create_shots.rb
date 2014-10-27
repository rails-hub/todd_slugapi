class CreateShots < ActiveRecord::Migration
  def change
    create_table :shots do |t|
      t.string :caption
      t.string :s3url
      t.integer :user_id

      t.timestamps
    end
  end
end
