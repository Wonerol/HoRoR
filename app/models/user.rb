class User < ActiveRecord::Base
  after_initialize :default_values
  has_many :armies, :dependent => :destroy
  before_save { email.downcase! }
  before_create :create_remember_token

  has_secure_password

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

    # needs error checking!!!
=begin
when no army exists for user_id, monster_id pair -> army count increases
when army exists "" -> army count stays the same increment monster_amount
monster_amount is a reasonable number
=end

  def recruit(monster, army, army_params, num_monsters)
    if num_monsters <= 0
      return false
    end

    new_gold = self.gold - (monster.cost * num_monsters)

    if new_gold < 0
      return false
    end

    self.assign_attributes({ :gold => new_gold })

    if army.nil?
      army = Army.new(user_id: army_params[:user_id],
                      monster_id: army_params[:monster_id],
                      monster_amount: army_params[:monster_amount],
                      ai_controlled: false)
    else
      new_num_monsters = army.monster_amount + num_monsters
      army.assign_attributes({ :monster_amount => new_num_monsters })
    end

    ActiveRecord::Base.transaction do
      army.save!
      self.save!(:validate => false)
    end

    return true
  end

  private
    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end

    def default_values
      self.gold ||= 5000
    end
end
