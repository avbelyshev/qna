require 'rails_helper'

RSpec.configure do |config|
  Capybara.javascript_driver = :webkit
  config.include AcceptanceHelper, type: :feature
end
