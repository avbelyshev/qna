FactoryBot.define do
  factory :answer do
    question nil
    sequence(:body) { |n| "AnswerBody#{n}" }
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
