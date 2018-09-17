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

    within '.question' do
      click_on 'Delete'

      expect(current_path).to eq questions_path
    end
    expect(page).to have_content 'Question was successfully destroyed.'
  end

  scenario 'Authenticated user tries to delete not his question' do
    sign_in(another_user)

    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Non-authenticated user tries to delete question' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Delete'
    end
  end
end
