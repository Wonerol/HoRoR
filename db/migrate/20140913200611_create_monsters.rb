class CreateMonsters < ActiveRecord::Migration
  def change
    create_table :monsters do |t|
      t.string :name

      t.timestamps
    end
    add_index :monsters, :name, unique: true
  end
end
