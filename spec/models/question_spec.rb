require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to :user }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscribers) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it_behaves_like 'attachable'
  it_behaves_like 'votable'
  it_behaves_like 'commentable'
end
