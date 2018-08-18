require_relative '../acceptance_helper'

feature 'Delete answer\'s attachment', %q{
  As an authenticated user
  I want to be able to delete answer's attachment
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  scenario 'Authenticated user tries to delete his answer\'s attachment', js: true do
    sign_in user
    visit question_path(question)

    within '.answer_attachments' do
      click_on 'Delete attachment'

      expect(page).to_not have_link 'spec_helper.rb'
    end

    expect(current_path).to eq question_path(question)
  end

  scenario 'Authenticated user tries to delete not his answer\'s attachment' do
    sign_in(another_user)
    visit question_path(question)

    within '.answer_attachments' do
      expect(page).to_not have_link 'Delete attachment'
    end
  end

  scenario 'Non-authenticated user tries to delete answer\'s attachment' do
    visit question_path(question)

    within '.answer_attachments' do
      expect(page).to_not have_link 'Delete attachment'
    end
  end
end
