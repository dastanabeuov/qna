require 'rails_helper'

feature 'User can see question any page', %q{
  In order to get question from a comunity
  As an authentiate user
  I'd like to be ask the question
} do

  given(:user) { create(:user) }
  given(:guest) { create(:user) }
  
  context "mulitple sessions" do
    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end
 
      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        visit new_question_path

        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'test text'
        click_on 'Save question'

        expect(page).to have_content 'Test question'
        expect(page).to have_content 'test text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end  
end