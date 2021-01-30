require 'rails_helper'

feature 'DELETE QUESTION', %q{
  Authenticated owner user delete link question
  Authenticated other user delete link question
  Unauthenticated user delete link question
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:link) { create(:link, linkable: question) }

  scenario 'Authenticated owner user delete link question', js: true do
    sign_in(users.first)
    visit questions_path
    click_on question.title

    within '.question .links' do
      click_on 'Remove'
    end

    # Accept pop-up alert
    #page.driver.browser.switch_to.alert.accept

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to_not have_link 'Google', href: 'https://google.com'
  end

  scenario "Authenticated other user delete link question", js: true do
    sign_in(users.last)
    visit questions_path
    click_on question.title

    within '.question .links' do
      expect(page).to_not have_selector 'Remove'
    end
  end

  scenario 'Unauthenticated user delete link question', js: true do
    visit questions_path
    click_on question.title

    within '.question .links' do
      expect(page).to_not have_selector 'Delete'
    end
  end
end