class AddGoldPrizeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gold_prize, :integer
  end
end
