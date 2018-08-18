require_relative '../acceptance_helper'

feature 'Delete question\'s attachment', %q{
  As an authenticated user
  I want to be able to delete question's attachment
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question) }

  scenario 'Authenticated user tries to delete his question\'s attachment', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question_attachments' do
      click_on 'Delete attachment'

      expect(current_path).to eq question_path(question)
      expect(page).to_not have_link 'spec_helper.rb'
    end
  end

  scenario 'Authenticated user tries to delete not his question\'s attachment' do
    sign_in(another_user)
    visit question_path(question)

    within '.question_attachments' do
      expect(page).to_not have_link 'Delete attachment'
    end
  end

  scenario 'Non-authenticated user tries to delete question\'s attachment' do
    visit question_path(question)

    within '.question_attachments' do
      expect(page).to_not have_link 'Delete attachment'
    end
  end
end
