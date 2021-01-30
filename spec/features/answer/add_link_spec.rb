require 'rails_helper'

feature 'CREATE LINK', %q{
  Authenticated user create link
  Authenticated user create with errors link
  Unauthenticated user create link
  Authenticated user create link to Github(Gist)
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:google_url) { 'https://google.com/' }
  given(:invalid_url) { 'htt://google.com/' }

  scenario 'Authenticated user create link', js: true do
    sign_in(user)
    visit edit_question_path(question)

    click_on 'Add link'

    within all('#links .nested-fields').last do
      fill_in 'name', with: 'Google'
      fill_in 'url', with: google_url
    end

    click_on 'Save'

    expect(page).to have_link 'Google', href: google_url
  end

  scenario 'Authenticated user create with errors link', js: true do
    sign_in(user)
    visit edit_question_path(question)

    click_on 'Add link'

    within all('#links .nested-fields').last do
      fill_in 'name', with: 'Google'
      fill_in 'url', with: invalid_url
    end

    click_on 'Save'

    expect(page).to have_content 'Links url is not a valid url'
    expect(page).to_not have_link 'Google', href: invalid_url
  end

  scenario 'Unauthenticated user create link', js: true do
    visit edit_question_path(question)

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user create link to Github(Gist)' do
    context 'valid attributes' do
      given(:gist_url) { 'https://gist.github.com/dastanabeuov/2315ed37f2ce1dd86456ad6c836eff8c' }
      sign_in(user)
      visit edit_question_path(question)

      click_on 'Add link'

      within all('#links .nested-fields').last do
        fill_in 'name', with: 'RVM & Rails setup'
        fill_in 'url', with: gist_url
      end

      click_on 'Save'

      wait_for_ajax
      expect(page).to have_content 'RVM & Rails setup'
      expect(page).to have_link 'RVM & Rails setup', href: gist_url
    end

    context 'invalid attributes' do
      given(:invalid_gist_url) { 'https://gist.github.com/dastanabeuov/empty' }
      sign_in(user)
      visit edit_question_path(question)

      click_on 'Add link'

      within all('#links .nested-fields').last do
        fill_in 'name', with: 'Invalid Gist'
        fill_in 'url', with: invalid_gist_url
      end

      click_on 'Save'

      wait_for_ajax
      expect(page).to have_content 'Your Gist has not been created!'
      expect(page).to have_link 'Invalid Gist', href: invalid_gist_url
    end
  end
end

