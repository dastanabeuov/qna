require 'rails_helper'

feature 'User can add links answer from question', %q{
  In order to provide additional info to my question
  As question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:google_url) { 'https://google.com/' }

  background do
    sign_in(user)
    visit question_path(question)
  end

  describe 'User adds a regular link when asking a question' do
    scenario 'it is a vallid link', js: true do
      fill_in 'body', with: 'body text...'

      within all('#links .nested-fields').last do
        fill_in 'name', with: 'Google'
        fill_in 'url', with: google_url
      end

      click_on 'Add link'

      within all('#links .nested-fields').last do
        fill_in 'name', with: 'Google'
        fill_in 'url', with: google_url
      end

      click_on 'Save'

      expect(page).to have_link 'Google', href: google_url
      expect(page).to have_link 'Google', href: google_url
    end

    scenario 'it is an invalid link', js: true do
      fill_in 'body', with: 'body text...'

      within all('#links .nested-fields').last do
        fill_in 'name', with: 'Google'
        fill_in 'url', with: 'invalid link'
      end

      click_on 'Save'

      expect(page).to have_content 'Links url is not a valid url'
      expect(page).to_not have_link 'Google', href: 'invalid link'
   end
  end

  describe 'User adds a link to Github Gist when asking a question' do
    given(:gist_url) { 'https://gist.github.com/dastanabeuov/2315ed37f2ce1dd86456ad6c836eff8c' }
    given(:invalid_gist_url) { 'https://gist.github.com/dastanabeuov/empty' }

    scenario 'it is a valid Gist link', js: true do
      fill_in 'body', with: 'body text...'

      within all('#links .nested-fields').last do
        fill_in 'name', with: 'RVM & Rails setup'
        fill_in 'url', with: gist_url
      end

      click_on 'Save'

      wait_for_ajax
      expect(page).to have_content 'RVM & Rails setup'
      expect(page).to have_link 'RVM & Rails setup', href: gist_url
    end

    scenario 'it is an invalid Gist link', js: true do
      fill_in 'body', with: 'body text...'

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

