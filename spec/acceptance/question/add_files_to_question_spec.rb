require_relative '../acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
  end

  scenario 'User adds file when asks question', js: true do
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb'
  end

  scenario 'User adds multiple files when asks question', js: true do
    click_on 'Attach file'

    within first('.nested-fields') do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb'
  end
end
