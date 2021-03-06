require_relative '../acceptance_helper'

feature 'Delete answer', %q{
  As an authenticated user
  I want to be able to delete my answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user tries to delete his answer', js: true do
    sign_in(user)

    visit question_path(question)

    within '.answers' do
      click_on 'Delete'
    end

    expect(page).to_not have_content answer.body
  end

  scenario 'Authenticated user tries to delete not his answer' do
    sign_in(another_user)

    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Non-authenticated user tries to delete answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Delete'
    end
  end
end
