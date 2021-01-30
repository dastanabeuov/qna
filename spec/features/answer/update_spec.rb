require 'rails_helper'

feature 'UPDATE ANSWER', %q{
  Authenticated user update
  Other authenticated user update
  Unauthenticated user update
} do

  given(:user) { create(:user) }
  given(:user2 create(:user) }
  given(:question) { create(:question, user: user ) }
  given!(:answer) { create(:answer, question: question, user: user) }

  before { sign_in(user) }

  scenario 'Authenticated user update' do
    visit question_path(question)

    within '.answers' do
      click_on 'Edit answer'

      fill_in 'Body', with: 'NewText'
      click_on 'Save'
    end

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'NewText'
    end
  end

  scenario 'tries to update his answer with invalid attributes', js: true do
    within '.answers' do
      click_on 'Edit answer'

      fill_in 'Body', with: ''
      click_on 'Save'
    end

      expect(current_path).to eq question_path(question)
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Other authenticated user update' do
    sign_in(non_author) }

    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit answer'
    end
  end

  scenario 'Unauthenticated user update' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit answer'
    end
  end
end