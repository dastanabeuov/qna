require 'rails_helper'

feature 'User can delete answer', %q{
  Authenticate user can delete his answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer) }

  scenario 'delete answer if user logged' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'Your answer has been deleted.'
    expect(page).to have_no_content 'MyTextAnswer'
  end

  describe 'button for Delete answer is not visible' do
    given(:other_user) { create(:user) }
    given!(:answer) { create :answer, question: question, author: other_user }

    scenario 'if the user is not the author' do
      sign_in(user)

      visit question_path(question)
      expect(page).to have_no_link('Delete')
    end

    scenario 'If the user is not logged in' do
      visit question_path(question)
      expect(page).to have_no_link('Delete')
    end
  end

end