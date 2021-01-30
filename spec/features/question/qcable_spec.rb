require 'rails_helper'

feature 'ACTION CABLE QUESTION COMMENTS', %q{
  Appears on another user's page and add comments.
  Appears on another user's page question comments.
} do

  given(:user) { create(:user) }
  given(:guest) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  
  scenario "Appears on another user's page question." do
    Capybara.using_session('user') do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'MyString'
      fill_in 'Body', with: 'MyText'
      click_on 'Save question'

      expect(page).to have_content 'MyString'
      expect(page).to have_content 'MyText'
    end

    Capybara.using_session('guest') do
      sign_in(guest)

      expect(page).to have_content 'MyString'
      expect(page).to have_content 'MyText'
    end
  end
  
  scenario "Appears on another user's page question comments." do
    Capybara.using_session('user') do
      sign_in(user)
      visit questions_path

      click_on 'Ask question'

      fill_in 'Title', with: 'MyString'
      fill_in 'Body', with: 'MyText'

      within '.question .comments' do
        fill_in 'Text', with: 'MyText'
      end

      click_on 'Save question'

      within '.question .comments' do
        expect(page).to have_content 'MyText'
      end
    end

    Capybara.using_session('guest') do
      sign_in(guest)
      visit question_path(question)
      
      within '.question .comments' do
        expect(page).to have_content 'MyText'
      end
    end
  end  
end