require_relative '../acceptance_helper'

feature 'Add comment to answer', %q{
  As an authenticated user
  I want to be able to comment an answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates comment for answer with valid attributes', js: true do
      within '.answer_comments' do
        click_on 'Add comment'
        fill_in 'Comment', with: 'New comment'
        click_on 'Comment'
        expect(page).to have_content 'New comment'
      end
    end

    scenario 'creates comment for answer with invalid attributes', js: true do
      within '.answer_comments' do
        click_on 'Add comment'
        fill_in 'Comment', with: ''
        click_on 'Comment'
        expect(page).to have_content 'Body can\'t be blank'
      end
    end
  end

  scenario 'Non-authenticated user tries to create comment for answer' do
    visit question_path(question)

    within '.answer_comments' do
      expect(page).to_not have_link 'Add comment'
    end
  end
end
