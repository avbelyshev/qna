require_relative '../acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'Answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
  end

  scenario 'User adds file when answer question', js: true do
    click_on 'Reply'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'User adds multiple files when answer question', js: true do
    click_on 'Attach file'

    within first('.nested-fields') do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Reply'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb'
    end
  end
end
