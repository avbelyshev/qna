require_relative '../acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask question
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question with valid attributes' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'
    click_on 'Create'

    expect(page).to have_content 'Question was successfully created.'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'text text'
  end

  scenario 'Authenticated user creates question with invalid attributes' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    click_on 'Create'

    expect(page).to have_content 'Title can\'t be blank'
    expect(page).to have_content 'Body can\'t be blank'
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path

    expect(page).to_not have_link 'Ask question'
  end

  context 'multiple sessions' do
    scenario 'question appears on another user\'s page', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text'
        click_on 'Create'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end
end
