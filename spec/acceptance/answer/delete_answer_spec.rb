require 'rails_helper'

feature 'Delete answer', %q{
  As a authenticate user
  I want to be able to delete my answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticate user tries to delete his answer' do
    sign_in(user)

    visit question_path(question)
    click_on 'Delete answer'

    expect(page).to have_content 'The answer is successfully deleted.'
    expect(page).to_not have_content answer.body
  end

  scenario 'Authenticate user tries to delete not his answer' do
    sign_in(another_user)

    visit question_path(question)
    expect(page).to_not have_link 'Delete answer'
  end

  scenario 'Non-authenticated user tries to delete answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
end
