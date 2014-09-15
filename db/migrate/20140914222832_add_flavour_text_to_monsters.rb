class AddFlavourTextToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :flavour_text, :string
  end
end
