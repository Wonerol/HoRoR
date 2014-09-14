require 'spec_helper'

# Army page display is currently handled by User Controller
# This separate file is to avoid bloating user_pages_spec

describe "Army pages" do

  subject { page }

  describe "overview page" do
    let(:army) { FactoryGirl.create(:army) }
    let(:user) { FactoryGirl.create(:user) }

    before do
      sign_in user
      visit user_path(user) + "/army"
    end

    it { should have_title('Army Overview') }
    it { should have_content('Your Army') }
  end

end
