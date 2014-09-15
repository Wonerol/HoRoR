class ChangeFlavourStringToFlavourText < ActiveRecord::Migration
  def change
    change_column :monsters, :flavour_text, :text
  end
end
