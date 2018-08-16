require_relative '../acceptance_helper'

feature 'Question editing', %q{
  In order to fix mistake
  As an author of question
  I'd like to be able to edit my question
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Author' do
    before do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'sees link to Edit' do
      within '.question' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'try to edit his question', js: true do
      within '.question' do
        click_on 'Edit'
        fill_in 'Title', with: 'new title'
        fill_in 'Body', with: 'new body'
        click_on 'Save'
        expect(page).to_not have_content question.body
        expect(page).to have_content 'new title'
        expect(page).to have_content 'new body'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end

  scenario 'Authenticated user try to edit other user\'s question' do
    sign_in(another_user)

    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end
end
