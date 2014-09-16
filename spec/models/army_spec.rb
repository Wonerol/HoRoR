require 'spec_helper'

describe Army do

  let(:user) { FactoryGirl.create(:user) }
  let(:monster) { FactoryGirl.create(:monster) }

  before do
    @army = Army.new(user_id: user.id, monster_id: monster.id, monster_amount: 10, ai_controlled: false)
  end

  subject { @army }

  it { should respond_to(:user_id) }
  it { should respond_to(:monster_id) }
  it { should respond_to(:monster_amount) }
  it { should respond_to(:ai_controlled) }

end
