require 'rails_helper'

feature 'User can delete answer', %q{
  Authenticate user can delete his answer
} do

  given(:user) { create(:user) }
  given(:question) { create :question, user_id: user.id }
  given!(:answer) { create :answer, question: question, user_id: user.id }

  scenario 'delete answer if user logged' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete answer'
    expect(page).to have_content 'Your answer has been deleted.'
    expect(page).to have_no_content 'MyTextAnswer'
  end

  describe 'button for Delete answer is not visible' do
    given(:invalid_user) { create(:user) }
    given(:invalid_question) { create :question, user_id: invalid_user.id }
    given!(:answer) { create :answer, question: invalid_question, user_id: invalid_user.id }

    scenario 'if the user is not the author' do
      sign_in(user)
      visit question_path(invalid_question)
      expect(page).to have_no_link('Delete question')
    end

    scenario 'If the user is not logged in' do
      visit question_path(invalid_question)
      expect(page).to have_no_link('Delete answer')
    end
  end

end