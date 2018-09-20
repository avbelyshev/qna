require_relative '../acceptance_helper'

feature 'Sign in with social networks accounts', %q{
  As an  user
  I want to be able to authorization with social networks accounts
} do

  scenario 'can sign in user with Vkontakte account' do
    visit new_user_session_path
    mock_auth_hash_vkontakte
    click_on 'Sign in with Vkontakte'

    expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
    expect(page).to have_content 'user@qna.com'
  end

  scenario 'can sign in user with GitHub account' do
    visit new_user_session_path
    mock_auth_hash_github
    click_on 'Sign in with GitHub'

    expect(page).to have_content 'Successfully authenticated from GitHub account.'
    expect(page).to have_content 'user@qna.com'
  end

  it 'can handle authentication error' do
    OmniAuth.config.mock_auth[:vkontakte] = :invalid_credentials
    visit new_user_session_path
    click_on 'Sign in with Vkontakte'

    expect(page).to have_content "Could not authenticate you from Vkontakte because \"Invalid credentials\""
  end
end
