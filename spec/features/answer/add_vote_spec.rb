require 'rails_helper'

feature 'ADD VOTE', %q{
  Authenticated user can vote for answer
  Authenticated User can vote for answer only once
  Authenticated user can cancel his vote and re-vote
  Authenticated user can not vote for his answer
} do

  given (:question_author) { create(:user) }
  given (:answer_author) { create(:user) }
  given (:question) { create(:question, user: question_author) }
  given (:answer) { create(:answer, question: question, user: answer_author) }
  given (:second_answer) { create(:answer, question: question, user: question_author) }

  background do
    sign_in(question_author)
    visit question_path(question)
  end

  scenario 'Authenticated user can vote for answer' do
    within "#voting-#{answer.class.name.downcase}-#{answer.id}" do
      expect(page).to have_link 'arrow-up'
      expect(page).to have_link 'arrow-down'
      expect(page).to have_text '0'
    end
  end

  scenario 'Authenticated user can vote for answer only once' do
    within "#voting-#{answer.class.name.downcase}-#{answer.id}" do
      click_link 'arrow-up'
      expect(page).to have_text '1'
      expect(page).to_not have_link 'arrow-up'
      expect(page).to have_text 'Cancel my vote'
    end
  end

  scenario 'User can cancel his vote and re-vote' do
    within "#voting-#{answer.class.name.downcase}-#{answer.id}" do
      click_link 'arrow-up'
      expect(page).to have_text '1'
      click_link 'Cancel my vote'
      expect(page).to have_text '0'
      click_link 'arrow-down'
      expect(page).to have_text '-1'
    end
  end

  scenario 'User can not vote for his answer' do
    within "#voting-#{answer.class.name.downcase}-#{answer.id}" do
      expect(page).to_not have_link 'arrow-up'
      expect(page).to_not have_link 'arrow-down'
    end
  end
end