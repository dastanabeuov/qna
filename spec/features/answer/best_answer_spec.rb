require 'rails_helper'

feature 'Correct best answer', %q{
  In order to
  as an author
  i want to be able to Correct best answer
} do
  given(:author) { create(:user) }
  given(:non_author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  describe 'Authenticated user as' do
    describe "author" do
      before do
        sign_in(author)
        visit question_path(question)
      end
  
      scenario "sees 'Correct answer' link" do
        expect(page).to have_link "Correct answer"
      end

      scenario 'want to Correct answer', js: true do
        within '.answer:last-child' do
          click_on 'Correct answer'
        end
        within '.answer:first-child' do
          expect(page).to have_content answers.last.body
        end
      end
    end

    scenario "non author can't sees 'Correct answer' link" do
      sign_in(non_author)
      visit question_path(question)
      expect(page).to_not have_link "Correct answer"
    end
  end

  scenario 'Un-authenticated user want to Correct answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Correct answer'
  end
end