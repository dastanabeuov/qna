require 'rails_helper'

feature 'User can update his answer', "
  In order to correct or specify the answer
  As a User
  I'd like to be able to update my answer
" do
  given(:user) { create(:user) }
  given(:non_author) { create(:user) }
  given(:question) { create(:question, user: user ) }
  given!(:answer) { create(:answer, question: question, user: user) }

  context 'Authenticated user' do
    context 'as author of answer' do
      background do
        sign_in(user)

        visit question_path(question)
      end

      scenario 'updates his answer', js: true do
        within '.answers' do
          click_on 'Edit answer'

          fill_in 'Body', with: 'Updated Answer'
          click_on 'Save'
        end

        expect(current_path).to eq question_path(question)
        within '.answers' do
          expect(page).to have_content 'Updated Answer'
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

    context 'not as Author of answer' do
      background { sign_in(non_author) }

      scenario "tries to update other user's answer", js: true do
        visit question_path(question)

        within '.answers' do
          expect(page).to_not have_link 'Edit Answer'
        end
      end
    end
  end

  context 'Unauthenticated user' do
    scenario 'tries to update answer' do
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Edit Answer'
      end
    end
  end
end