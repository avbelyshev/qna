require 'rails_helper'

RSpec.describe User do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:resource) { create(:question, user: user) }

    it 'Returns true if resource belongs to user' do
      expect(user).to be_author_of(resource)
    end

    it 'Returns false if resource does not belongs to user' do
      expect(another_user).to_not be_author_of(resource)
    end
  end
end
