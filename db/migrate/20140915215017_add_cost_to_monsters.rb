class AddCostToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :cost, :integer
  end
end
