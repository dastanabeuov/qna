require 'rails_helper'

feature 'DELETE LINK', %q{
  Authenticated user delete answer link
  Other authenticated user's try delete answer link
  Unauthenticated user tries delete answer link
} do

  given(:users) { (:user) }
  given(:users2) { (:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:link) { create(:link, linkable: answer) }

  scenario 'Authenticated user delete answer link' do
    sign_in(user)
    visit questions_path(question)

    within '.answers .links' do
      click_on 'Remove'
    end

    # Accept pop-up alert
    # page.driver.browser.switch_to.alert.accept

    expect(page).to have_content answer.body
    expect(page).to_not have_link 'Google', href: 'https://google.com'
  end

  scenario "Other authenticated user's try delete answer link" do
    sign_in(users.last)
    visit question_path(question)

    within '.answers .links' do
      expect(page).to_not have_link 'Remove'
    end
  end

  scenario 'Unauthenticated user tries delete answer link' do
    visit question_path(question)

    within '.answers .links' do
      expect(page).to_not have_link 'Delete'
    end
  end
end