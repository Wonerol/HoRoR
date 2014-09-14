class CreateArmies < ActiveRecord::Migration
  def change
    create_table :armies do |t|
      t.integer :monster_id
      t.integer :monster_amount
      t.integer :user_id

      t.timestamps
    end
  end
end
