require_relative '../acceptance_helper'

feature 'Create answer', %q{
  As an authenticated user
  I can answer the question
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

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

    expect(page).to_not have_content 'Your answer'
    expect(page).to_not have_link 'Reply'
  end

  context 'multiple sessions' do
    scenario 'answer appears on another user\'s page', js: true do
      Capybara.using_session('another_user') do
        sign_in(another_user)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('another_user') do
        fill_in 'Your answer', with: 'Answer'
        click_on 'Reply'

        expect(current_path).to eq question_path(question)
        within '.answers' do
          expect(page).to have_content 'Answer'
        end
      end

      Capybara.using_session('user') do
        within '.answers' do
          expect(page).to have_content 'Answer'
          expect(page).to have_content 'Rating:'
          expect(page).to have_link 'like'
          expect(page).to have_link 'dislike'
          expect(page).to have_link 'cancel vote'
          expect(page).to have_link 'Choose as the best'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'Answer'
          expect(page).to_not have_link 'like'
          expect(page).to_not have_link 'dislike'
          expect(page).to_not have_link 'cancel vote'
        end
      end
    end
  end
end
