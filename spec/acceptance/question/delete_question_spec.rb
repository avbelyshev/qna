require_relative '../acceptance_helper'

feature 'Delete question', %q{
  As an authenticated user
  I want to be able to delete my questions
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user tries to delete his question' do
    sign_in(user)

    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'The question is successfully deleted.'
    expect(current_path).to eq questions_path
  end

  scenario 'Authenticated user tries to delete not his question' do
    sign_in(another_user)

    visit question_path(question)
    expect(page).to_not have_link 'Delete'
  end

  scenario 'Non-authenticated user tries to delete question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end
end
