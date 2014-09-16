class AddAiControlledToArmies < ActiveRecord::Migration
  def change
    add_column :armies, :ai_controlled, :boolean
  end
end
