require_relative '../acceptance_helper'

feature 'Vote for question', %q{
  As an authenticated user
  I want to be able to vote for
  or against a question and see its rating
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe 'Authenticated user' do
    before { sign_in(user) }

    scenario 'tries to like not his question', js: true do
      visit question_path(question)
      within '.question_rating' do
        click_on 'like'
        sleep 1
        within '.rating' do
          expect(page).to have_content question.rating
        end
      end
    end

    scenario 'tries to dislike not his question', js: true do
      visit question_path(question)
      within '.question_rating' do
        click_on 'dislike'
        sleep 1
        within '.rating' do
          expect(page).to have_content question.rating
        end
      end
    end

    scenario 'tries to cancel vote', js: true do
      visit question_path(question)
      within '.question_rating' do
        click_on 'like'
        sleep 1
        click_on 'cancel vote'
        sleep 1
        within '.rating' do
          expect(page).to have_content question.rating
        end
      end
    end
  end

  scenario 'Author of question does not see the voting links' do
    sign_in(author)
    visit question_path(question)
    within '.question_rating' do
      expect(page).to_not have_link 'like'
      expect(page).to_not have_link 'dislike'
      expect(page).to_not have_link 'cancel vote'
      expect(page).to have_content question.rating
    end
  end

  scenario 'Non-authenticated user does not see the voting links for a question' do
    visit question_path(question)
    within '.question_rating' do
      expect(page).to_not have_link 'like'
      expect(page).to_not have_link 'dislike'
      expect(page).to_not have_link 'cancel vote'
      expect(page).to have_content question.rating
    end
  end
end
