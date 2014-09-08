require 'spec_helper'

describe "StaticPages" do

  let(:base_title) { "HoRoR" }

  describe "Home page" do
    it "should have the content 'home page'" do
        visit '/static_pages/home'
        expect(page).to have_content('home page')
    end
  end

  it "should have the right title" do
      visit '/static_pages/home'
      expect(page).to have_title("#{base_title}")
  end

  it "should not have a custom page title" do
      visit '/static_pages/home'
      expect(page).not_to have_title('| Home')
  end

  describe "Help page" do
    it "should have the content 'Help'" do
        visit '/static_pages/help'
        expect(page).to have_content('Help')
    end
  end

  it "should have the right title" do
      visit '/static_pages/help'
      expect(page).to have_title("#{base_title} | Help")
  end

  describe "About page" do
      it "should have the content 'About'" do
          visit '/static_pages/about'
          expect(page).to have_content('About')
      end
  end

  it "should have the right title" do
      visit '/static_pages/about'
      expect(page).to have_title("#{base_title} | About")
  end

  describe "Contact page" do
      it "should have the content 'Contact'" do
          visit '/static_pages/contact'
          expect(page).to have_content('Contact')
      end
  end

  it "should have the right title" do
      visit '/static_pages/contact'
      expect(page).to have_title("#{base_title} | Contact")
  end

end
