require 'rails_helper'

feature 'User sign up', %q{
  In order to be able to ask question
  As an user
  I want to be able to sign up
 } do

  given(:user) { create(:user) }

  scenario 'Non-registered user try to sign up' do
    sign_up(user)

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Registered user try to sign up' do
    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
    expect(current_path).to eq user_registration_path
  end
end
