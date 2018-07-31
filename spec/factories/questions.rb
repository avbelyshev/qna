FactoryBot.define do
  sequence(:title) { |n| "QuestionTitle#{n}" }
  sequence(:body) { |n| "QuestionBody#{n}" }

  factory :question do
    title
    body
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
