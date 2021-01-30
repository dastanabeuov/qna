require 'rails_helper'

feature 'User can view list of received awards', %q{
  Authenticated user sees list of his awards
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:award) { create(:award, question: question, recipient: user) }

  scenario 'Authenticated user sees list of his awards' do
    sign_in(user)
    visit awards_path

    expect(page).to have_content award.title
    expect(page).to have_link award.question.title, href: question_path(award.question)
  end
end