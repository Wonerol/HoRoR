class Army < ActiveRecord::Base
  belongs_to :user

  def get_gold_value
    return Monster.find(self.monster_id).cost * self.monster_amount
  end
end
