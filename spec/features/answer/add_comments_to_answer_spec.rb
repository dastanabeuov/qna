require 'rails_helper'

feature 'Add comments to answer', %q{
  In order to share opinion
  As an authnticated user
  i'd like to be able to add comments
} do
  
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'As authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'add comment with valid attributes', js: true do
      within '.answer-comment-form' do
        fill_in 'Text',	with: 'Comment body' 
        click_on 'Save comment'
      end

      within ".answer-#{answer.id}-comments-list" do
        expect(page).to have_content 'Comment body'
      end
    end

    scenario 'add comment with invalid attributes', js: true do
      within '.answer-comment-form' do
        click_on 'Save comment'
      end

      within ".answer-#{answer.id}-comments-list" do
        expect(page).to_not have_selector "li"
      end
    end
  end

  describe 'As un-authenticated user' do
    scenario 'wants add comment', js: true do
      visit question_path(question)

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end