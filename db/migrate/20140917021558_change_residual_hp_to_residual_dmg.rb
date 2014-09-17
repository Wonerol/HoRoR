class ChangeResidualHpToResidualDmg < ActiveRecord::Migration
  def change
    rename_column :armies, :residual_hp, :residual_dmg
  end
end
