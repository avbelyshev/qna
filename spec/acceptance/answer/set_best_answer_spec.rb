require_relative '../acceptance_helper'

feature 'Best answer', %q{
  As a author of the question
  I want to be able to choose answer as the best
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user try to choose best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Choose as the best'
  end

  describe 'Author of question' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to set best' do
      expect(page).to have_link 'Choose as the best'
    end

    scenario 'chooses best answer', js: true do
      within ".answer_#{answer.id}" do
        click_on 'Choose as the best'
        expect(page).to_not have_link 'Choose as the best'
        expect(page).to have_content '(Best answer)'
      end
    end
  end

  scenario 'Authenticated user does not see link to set best on other user\'s question page' do
    sign_in(another_user)

    expect(page).to_not have_link 'Choose as the best'
  end
end
