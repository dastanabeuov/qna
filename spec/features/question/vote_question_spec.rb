require 'rails_helper'

feature 'Vote a question', %q{
  To promote a question
  As an authenticated user
  I want to vote for it
}, type: :feature, js: true do
  given! (:user) { create(:user) }
  given! (:user2) { create(:user) }
  given! (:question) { create(:question, user: user) }
  given! (:second_question) { create(:question, user: user2) }

  background do
    sign_in(user2)
    visit question_path(question)
  end

  scenario 'User can vote for question' do
    within "#vote_for_Question_#{ question.id }" do
      expect(page).to have_link 'arrow-up'
      expect(page).to have_link 'arrow-down'
      expect(page).to have_text '0'
    end
  end

  scenario 'User can vote for question only once' do
    within "#vote_for_Question_#{ question.id }" do
      click_link 'arrow-up'
      expect(page).to have_text '1'
      expect(page).to_not have_link 'arrow-up'
      expect(page).to have_text 'Cancel my vote'
    end
  end

  scenario 'User can cancel his vote and re-vote' do
    within "#vote_for_Question_#{ question.id }" do
      click_link 'arrow-up'
      expect(page).to have_text '1'
      click_link 'Cancel my vote'
      expect(page).to have_text '0'
      click_link 'arrow-down'
      expect(page).to have_text '-1'
    end
  end

  scenario 'User can not vote for his question' do
    visit question_path(second_question)
    within '.question' do
      expect(page).to_not have_link 'arrow-up'
      expect(page).to_not have_link 'arrow-down'
    end
  end
end