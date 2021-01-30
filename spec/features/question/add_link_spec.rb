require 'rails_helper'

feature 'ADD LINK QUESTION', %q{
  authenticate user add vallid attributes
  Authenticate user add invallid attributes
  Authenticate user add valid_gist_url attributes
  Authenticate user add invallid_gist_url attributes
} do

  given(:user) { create(:user) }
  given(:google_url) { 'https://google.com/' }
  given(:gist_url) { 'https://gist.github.com/dastanabeuov/2315ed37f2ce1dd86456ad6c836eff8c' }
  given(:invalid_gist_url) { 'https://gist.github.com/dastanabeuov/empty' }

  background do
    sign_in(user)
    visit questions_path
    click_on 'Ask questions'
  end

  scenario 'Authenticate user add vallid attributes', js: true do
    fill_in 'Title', with: 'MyString'
    fill_in 'Body', with: 'MyText'

    within all('#links .nested-fields').last do
      fill_in 'name', with: 'Google'
      fill_in 'url', with: google_url
    end

    click_on 'Add link'

    within all('#links .nested-fields').last do
      fill_in 'name', with: 'Google'
      fill_in 'url', with: google_url
    end

    click_on 'Save question'

    expect(page).to have_link 'Google', href: google_url
    expect(page).to have_link 'Google', href: google_url
  end

  scenario 'Authenticate user add invallid attributes', js: true do
    fill_in 'Title', with: 'MyString'
    fill_in 'Body', with: 'MyText'

    within all('#links .nested-fields').last do
      fill_in 'name', with: 'Google'
      fill_in 'url', with: invalid_link
    end

    click_on 'Save question'

    expect(page).to have_content 'Links url is not a valid url'
    expect(page).to_not have_link 'Google', href: invalid_link
  end

  scenario 'Authenticate user add valid_gist_url attributes', js: true do
    fill_in 'Title', with: 'MyString'
    fill_in 'Body', with: 'MyText'

    within all('#links .nested-fields').last do
      fill_in 'name', with: 'RVM & Rails setup'
      fill_in 'url', with: gist_url
    end

    click_on 'Save question'

    wait_for_ajax
    expect(page).to have_content 'RVM & Rails setup'
    expect(page).to have_link 'RVM & Rails setup', href: gist_url
  end

  scenario 'Authenticate user add invallid_gist_url attributes', js: true do
    fill_in 'Title', with: 'MyString'
    fill_in 'Body', with: 'MyText'

    within all('#links .nested-fields').last do
      fill_in 'name', with: 'Invalid Gist'
      fill_in 'url', with: invalid_gist_url
    end

    click_on 'Save question'

    wait_for_ajax
    expect(page).to have_content 'Your Gist has not been created!'
    expect(page).to have_link 'Invalid Gist', href: invalid_gist_url
  end
end

