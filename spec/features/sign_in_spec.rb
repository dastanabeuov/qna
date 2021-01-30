require 'rails_helper'

feature 'User can signin', %q{
  Registration user tries sign in
  Unregistered user tries sign in
  User can logout system
  User can register on system
} do
  given(:user) { create(:user) }
  
  background { visit new_user_session_path }

  scenario 'Registration user tries sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user tries sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'
    
    expect(page).to have_content 'Invalid Email or password.'
  end

  scenario 'User can logout system' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    visit questions_path
    click_on 'Logout'
    
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'User can register on system' do
    visit new_user_registration_path
    fill_in 'Email', with: 'newuser@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'
    
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end