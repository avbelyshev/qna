require_relative '../acceptance_helper'

feature 'User log out', %q{
  As a logged user
  I want to be able to log out
 } do

  given(:user) { create(:user) }

  scenario 'Authenticated user tries to log out' do
    sign_in(user)

    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end
