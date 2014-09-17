class AddResidualHpToArmy < ActiveRecord::Migration
  def change
    add_column :armies, :residual_hp, :integer
  end
end
