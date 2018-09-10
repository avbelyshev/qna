require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to :votable }
  it { should validate_presence_of :value }
  it { should allow_value(1, -1).for(:value) }
end
