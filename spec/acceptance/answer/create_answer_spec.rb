require 'rails_helper'

feature 'Create answer', %q{
  As an authenticated user
  I can answer the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user creates answer with valid attributes', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'Your answer', with: 'Answer'
    click_on 'Reply'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'Answer'
    end
  end

  scenario 'Authenticated user creates answer with invalid attributes', js: true do
    sign_in(user)

    visit question_path(question)
    click_on 'Reply'

    expect(page).to have_content 'Body can\'t be blank'
  end

  scenario 'Non-authenticated user tries to create answer' do
    visit question_path(question)
    fill_in 'Your answer', with: 'Answer'
    click_on 'Reply'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
