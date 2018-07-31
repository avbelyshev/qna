require 'rails_helper'

feature 'Show question and answers to it', %q{
  User can view the question and answers to it
} do

  given(:question) { create(:question) }
  given(:answers) { create_list(:answer, 3, question: question) }

  scenario 'User can view the question and answers to it' do
    visit(question_path(question))

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    question.answers.each { |answer| expect(page).to have_content answer.body }
  end
end
