require 'spec_helper'
include ApplicationHelper

describe "Monster pages" do

  subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before do 
      sign_in user
      visit monsters_path
    end

    FactoryGirl.create(:monster)

    it { should have_title('Monster Market') }
    it { should have_content('Monster Market') }

    describe "pagination" do
      before(:all) { 30.times { FactoryGirl.create(:monster) } }
      after(:all)  { Monster.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each monster" do
        Monster.paginate(page: 1).each do |monster|
          expect(page).to have_content(monster.name)
        end
      end
    end

  end

  describe "monster profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let(:monster) { FactoryGirl.create(:monster) }
    before do 
      sign_in user
      visit monster_path(monster)
    end

    it { should have_content(monster.name) }
    it { should have_title(monster.name) }

    it "allows recruitment" do
      expect { click_button "Recruit" }.to change(Army, :count).by(1)
    end
  end

end
