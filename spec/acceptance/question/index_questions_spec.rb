require 'rails_helper'

feature 'Index questions', %q{
  User can view the list of questions
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user) }

  scenario 'User can view the list of questions' do
    visit questions_path

    questions.each do |q|
      expect(page).to have_content q.title
      expect(page).to have_content q.body
    end
  end
end
