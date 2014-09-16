class Monster < ActiveRecord::Base
  validates :name, :cost, presence: true
end
