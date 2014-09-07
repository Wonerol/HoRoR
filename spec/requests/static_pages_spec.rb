require 'spec_helper'

describe "StaticPages" do
  describe "Home page" do
    it "should have the content 'home page'" do
        visit '/static_pages/home'
        expect(page).to have_content('home page')
    end
  end

  it "should have the right title" do
      visit '/static_pages/home'
      expect(page).to have_title("HoRoR | Home")
  end

  describe "Help page" do
    it "should have the content 'Help'" do
        visit '/static_pages/help'
        expect(page).to have_content('Help')
    end
  end

  it "should have the right title" do
      visit '/static_pages/help'
      expect(page).to have_title("HoRoR | Help")
  end

  describe "About page" do
      it "should have the content 'About'" do
          visit '/static_pages/about'
          expect(page).to have_content('About')
      end
  end

  it "should have the right title" do
      visit '/static_pages/about'
      expect(page).to have_title("HoRoR | About")
  end

end
