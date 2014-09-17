class AddCombatFieldsToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :attack, :integer
    add_column :monsters, :defence, :integer
    add_column :monsters, :hp, :integer
    add_column :monsters, :min_damage, :integer
    add_column :monsters, :max_damage, :integer
    add_column :monsters, :speed, :integer
  end
end
