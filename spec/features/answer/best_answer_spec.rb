require 'rails_helper'

feature 'CHOOSE BEST', %q{
  Authenticated user correct best
  Authenticated user non author question
  Unauthenticated user try change correct best
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user ) }

  scenario 'Authenticated user correct best', js: true do
    sign_in(author)
    visit question_path(question)

    visit question_path(question)

    click_on 'Correct answer'

    expect(page).to_not have_link 'The best Answer'
  end

  scenario "Authenticated user non author question" do
    sign_in(user2)

    visit question_path(question)
    
    expect(page).to_not have_link "Correct answer"
  end

  scenario 'Unauthenticated user try change correct best' do
    visit question_path(question)

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(page).to_not have_link 'Correct answer'
  end
end