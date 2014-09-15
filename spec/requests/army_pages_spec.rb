require 'spec_helper'

describe "Army pages" do

  subject { page }

  describe "overview page" do
    let(:user) { FactoryGirl.create(:user) }
    let(:army) { FactoryGirl.create(:army, user_id: user.id) }

    before do
      sign_in user
      visit army_path(user)
    end

    it { should have_title('Army Overview') }
    it { should have_content('Your Army') }
  end

end
