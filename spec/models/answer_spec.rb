require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }
  it { should validate_presence_of :body }
  it_behaves_like 'attachable'
  it_behaves_like 'votable'

  describe '#set_best!' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:another_answer) { create(:answer, question: question, user: user) }

    before { answer.set_best! }

    it 'should choose answer as the best' do
      expect(answer).to be_best
    end

    it 'should change the best answer' do
      another_answer.set_best!
      answer.reload
      expect(answer).to_not be_best
      expect(another_answer).to be_best
    end
  end
end
