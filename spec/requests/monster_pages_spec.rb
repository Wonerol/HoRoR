require 'spec_helper'

describe "Monster pages" do

  subject { page }

  describe "index" do
    before { visit monsters_path }

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
    let(:monster) { FactoryGirl.create(:monster) }
    before { visit monster_path(monster) }

    it { should have_content(monster.name) }
    it { should have_title(monster.name) }
  end

end
