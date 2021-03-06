FactoryBot.define do
  factory :question do
    user
    sequence(:title) { |n| "QuestionTitle#{n}" }
    sequence(:body) { |n| "QuestionBody#{n}" }
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
