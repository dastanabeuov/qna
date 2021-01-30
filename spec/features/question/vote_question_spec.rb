require 'rails_helper'

feature 'VOTE QUESTION', %q{
  Authenticate user vote question
  Authenticate user can vote question only once
  Authenticate user can cancel his vote and re-vote
  Authenticate author user can not vote question
} do
  
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:question2) { create(:question, user: user2) }

  background do
    sign_in(user2)
    visit question_path(question)
  end

  scenario 'Authenticate user vote question' do
    within "#vote_for_Question_#{ question.id }" do
      expect(page).to have_link 'arrow-up'
      expect(page).to have_link 'arrow-down'
      expect(page).to have_text '0'
    end
  end

  scenario 'Authenticate user can vote question only once' do
    within "#vote_for_Question_#{ question.id }" do
      click_link 'arrow-up'
    
      expect(page).to have_text '1'
      expect(page).to_not have_link 'arrow-up'
      expect(page).to have_text 'Cancel my vote'
    end
  end

  scenario 'Authenticate user can cancel his vote and re-vote' do
    within "#vote_for_Question_#{ question.id }" do
      click_link 'arrow-up'
      expect(page).to have_text '1'

      click_link 'Cancel my vote'
      expect(page).to have_text '0'

      click_link 'arrow-down'
      expect(page).to have_text '-1'
    end
  end

  scenario 'Authenticate author user can not vote question' do
    visit question_path(second_question)

    within '.question' do
      expect(page).to_not have_link 'arrow-up'
      expect(page).to_not have_link 'arrow-down'
    end
  end
end