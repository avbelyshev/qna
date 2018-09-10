require_relative '../acceptance_helper'

feature 'Vote for answer', %q{
  As an authenticated user
  I want to be able to vote for
  or against a answer and see its rating
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:answer) { create(:answer, user: author) }

  describe 'Authenticated user' do
    before { sign_in(user) }

    scenario 'tries to like not his answer', js: true do
      visit question_path(answer.question)
      within ".answer_#{answer.id}" do
        within '.answer_rating' do
          click_on 'like'
          within '.rating' do
            expect(page).to have_content answer.rating
          end
        end
      end
    end

    scenario 'tries to dislike not his answer', js: true do
      visit question_path(answer.question)
      within ".answer_#{answer.id}" do
        within '.answer_rating' do
          click_on 'dislike'
          within '.rating' do
            expect(page).to have_content answer.rating
          end
        end
      end
    end

    scenario 'tries to cancel vote', js: true do
      visit question_path(answer.question)
      within ".answer_#{answer.id}" do
        within '.answer_rating' do
          click_on 'like'
          click_on 'cancel vote'
          within '.rating' do
            expect(page).to have_content answer.rating
          end
        end
      end
    end
  end

  scenario 'Author of answer does not see the voting links' do
    sign_in(author)
    visit question_path(answer.question)
    within ".answer_#{answer.id}" do
      within '.answer_rating' do
        expect(page).to_not have_link 'like'
        expect(page).to_not have_link 'dislike'
        expect(page).to_not have_link 'cancel vote'
        expect(page).to have_content answer.rating
      end
    end
  end

  scenario 'Non-authenticated user does not see the voting links for a answer' do
    visit question_path(answer.question)
    within ".answer_#{answer.id}" do
      within '.answer_rating' do
        expect(page).to_not have_link 'like'
        expect(page).to_not have_link 'dislike'
        expect(page).to_not have_link 'cancel vote'
        expect(page).to have_content answer.rating
      end
    end
  end
end
