require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:another_question) { create(:question, user: another_user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:another_answer) { create(:answer, question: another_question, user: another_user) }
    let(:comment) { create(:comment, commentable: question, user: user) }
    let(:another_comment) { create(:comment, commentable: question, user: another_user)  }
    let(:attachment) { create(:attachment, attachable: question) }
    let(:another_attachment) { create(:attachment, attachable: another_question) }
    let(:subscription) { create(:subscription, user: user) }
    let(:another_subscription) { create(:subscription, user: another_user) }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

    context 'create' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
      it { should be_able_to :create, Subscription }
    end

    context 'update' do
      it { should be_able_to :update, question }
      it { should be_able_to :update, answer }
      it { should be_able_to :update, comment }
      it { should_not be_able_to :update, another_question }
      it { should_not be_able_to :update, another_answer }
      it { should_not be_able_to :update, another_comment }
    end

    context 'destroy' do
      it { should be_able_to :destroy, question }
      it { should be_able_to :destroy, answer }
      it { should be_able_to :destroy, comment }
      it { should be_able_to :destroy, attachment }
      it { should be_able_to :destroy, subscription }
      it { should_not be_able_to :destroy, another_question }
      it { should_not be_able_to :destroy, another_answer }
      it { should_not be_able_to :destroy, another_comment }
      it { should_not be_able_to :destroy, another_attachment }
      it { should_not be_able_to :destroy, another_subscription }
    end

    context 'set best answer' do
      it { should be_able_to :set_best, answer }
      it { should_not be_able_to :set_best, another_answer }
    end

    context 'voting' do
      it { should be_able_to [:set_like, :set_dislike], another_answer }
      it { should_not be_able_to [:set_like, :set_dislike], answer }
    end

    context 'cancel vote' do
      let!(:vote) { create :vote, votable: another_question, user: user }

      it { should be_able_to :cancel_vote, another_question }
      it { should_not be_able_to :cancel_vote, question }
    end
  end
end
