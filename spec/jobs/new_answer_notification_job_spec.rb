require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:question) { create :question }
  let(:subscriptions) { create_list :subscription, 2, question: question }
  let(:answer) { create :answer, question: question }

  it 'sends notification email to subscribers' do
    question.subscribers.each do |user|
      expect(NotificationsMailer).to receive(:new_answer).with(user, answer).and_call_original
    end

    NewAnswerNotificationJob.perform_now(answer)
  end
end
