require 'rails_helper'

feature 'CREATE COMMENT', %q{
  Authenticated user create
  Authnticated user create with errors
  Unauthnticated user try create comment
} do
  
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  before do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'Authenticated user create', js: true do
    within '.answer-comment-form' do
      fill_in 'Text',	with: 'MyText' 
      click_on 'Save comment'
    end

    within ".answer-#{answer.id}-comments-list" do
      expect(page).to have_content 'MyText'
    end
  end

  scenario 'authnticated user create with errors', js: true do
    within '.answer-comment-form' do
      click_on 'Save comment'
    end

    within ".answer-#{answer.id}-comments-list" do
      expect(page).to_not have_selector "li"
    end
  end

  scenario 'unauthnticated user try create comment', js: true do
    visit question_path(question)

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end