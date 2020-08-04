require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a comunity
  As an authentiate user
  I'd like to be ask the question
} do

  given(:user) { create(:user) }
  
  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask question'
    end
    
    scenario 'ask a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Text body'
      click_on 'Save question'
      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'Text body'
    end

    scenario 'ask question in errors' do
      click_on 'Save question'
      expect(page).to have_content "Title can't be blank"
    end

    scenario 'Save question with attached file' do
      fill_in 'Title', with: 'Title text'
      fill_in 'Body', with: 'Body text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Save question'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'      
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end