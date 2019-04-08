require 'rails_helper'

feature 'User can ses all created questions', %q{
  In order to answer to the question
  As a user
  I'd like to be able to see all created questions
} do
  
  given!(:questions) { create_list(:question, 5) }

  scenario 'user watch all questions' do
    visit questions_path

    questions.each { |question| expect(page).to have_content question.title }
  end

end