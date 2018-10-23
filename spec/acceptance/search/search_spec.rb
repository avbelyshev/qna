require_relative '../acceptance_helper'

feature 'Search', %q{
  As an user
  I want to be able to search information
} do

  given!(:user) { create(:user, email: 'search@test.com') }
  given!(:question) { create(:question, body: 'search') }
  given!(:answer) { create(:answer, body: 'search') }
  given!(:comment) { create(:comment, commentable: question, body: 'search') }

  %w(Questions Answers Comments Users).each do |search_object|
    scenario "search in #{search_object}", js: true do
      ThinkingSphinx::Test.run do
        visit questions_path

        within '.search' do
          fill_in 'search_text', with: 'search*'
          select search_object, from: 'search_object'
          click_on 'Search'
        end

        within '.search_results' do
          expect(page).to have_content 'search'
        end
      end
    end
  end

  scenario 'search in all', js: true do
    ThinkingSphinx::Test.run do
      visit questions_path

      within '.search' do
        fill_in 'search_text', with: 'search*'
        select 'All', from: 'search_object'
        click_on 'Search'
      end

      within '.search_results' do
        expect(page).to have_content(question.body)
        expect(page).to have_content(answer.body)
        expect(page).to have_content(comment.body)
        expect(page).to have_content(user.email)
      end
    end
  end
end
