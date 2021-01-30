require 'rails_helper'

feature 'WATCH ALL QUESTION', %q{
	User watch all questions
} do
  
  given(:user) { create(:user) }
  given(:questions) { create_list :question, 5, user: user }

  scenario 'User watch all questions' do
    visit questions_path

    questions.each { |question| expect(page).to have_content question.title }
  end
end