require 'rails_helper'

feature 'UPDATE QUESTION', %q{
  Authenticate user author update
  Authenticate user non author update
  Authenticate user update
} do
  
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user) }

  before do
    sign_in(user)
    visit question_path(question)
  end

  scenario "Authenticate user update" do
    click_on 'Edit question'
    
    within '.question' do
      fill_in "Title",	with: "NewString"
      fill_in "Body",	with: "NewText"
      click_on 'Save question'
    end

    expect(page).to have_content "NewString"
    expect(page).to have_content "NewText"
  end

  scenario "Authenticate user non author update" do
    sign_in(user2)
    visit question_path(question)
    
    expect(page).to_not have_link 'Edit question'
  end

  scenario "Authenticate user update" do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end  
end