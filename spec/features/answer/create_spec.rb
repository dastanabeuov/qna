require 'rails_helper'

feature 'User can create answer for the question', %q{
  In order to solve the requested issue
  As authenticated user
  I'd like to be able to answer the question on its page
} do
  
  given(:user) { create(:user) }
  given(:question) { create :question, user_id: user.id }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'create answer for the question' do
      fill_in 'Body', with: 'Answer text from question'
      click_on 'Answer on question'
      expect(page).to have_content 'Answer text from question'
    end

    scenario 'tries to create answer with wrong parameters for the question' do
      click_on 'Answer on question'
      #expect(page).to have_content "Your answer has not been published!"
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'Save answer with attached file' do
      fill_in 'Body', with: 'Answer Body text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer on question'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'      
    end    
  end

  scenario 'Unauthenticated user tries to create answer for the question' do
    visit question_path(question)
    within('.new_answer') { expect(page).to_not have_content 'Body' }
  end
end