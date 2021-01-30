require 'rails_helper'

feature 'ADD COMMENTS QUESTION', %q{
  Authenticated user add with valid attributes
  Authenticated user add with invalid attributes
  Unauthenticated user add
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user add with valid attributes' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    fill_in "Text", with: 'MyText'
    click_on 'Save comment'

    expect(page).to have_content 'MyText'
  end

  scenario 'Authenticated user add with invalid attributes' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    fill_in "Text", with: '' 
    click_on 'Save comment'

    expect(page).to have_content "Text can't be empty"
  end

  scenario 'Unauthenticated user add' do
    visit question_path(question)

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end