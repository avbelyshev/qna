require 'rails_helper'

feature 'Create answer', %q{
  As an authenticated user
  I can answer the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user creates answer' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: 'Answer'
    click_on 'Reply'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content 'Answer'
  end

  scenario 'Non-authenticated user tries to create answer' do
    visit question_path(question)
    fill_in 'Body', with: 'Answer'
    click_on 'Reply'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
