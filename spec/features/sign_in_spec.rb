require 'rails_helper'

feature 'User can signin', %q{
  Registration user tries sign in
  Unregistered user tries sign in
  User can logout system
  User can register on system
} do
  given(:user) { create(:user) }
  given(:invalid_user) { attributes_for(:user, email: 'wrong@test.com', password: '123456' ) }
  given(:user_registered) { attributes_for(:user, email: 'newuser@test.com', password: '123456', password_confiramtion: '123456' ) }
  
  background { visit new_user_session_path }

  scenario 'Registration user tries sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user tries sign in' do
    sign_in(invalid_user)
    
    expect(page).to have_content 'Invalid Email or password.'
  end

  scenario 'User can logout system' do
    sign_in(user)
    
    visit questions_path
    click_on 'Logout'
    
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'User can register on system' do
    sign_up(user_registered)
    
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end