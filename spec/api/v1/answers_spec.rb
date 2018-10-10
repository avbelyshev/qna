require 'rails_helper'

describe 'Answers API' do
  let(:access_token) { create(:access_token) }
  let(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 2, question: question) }
  let!(:answer) { answers.first }
  subject { answer }
  let!(:type) { answer.class.name.downcase }

  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      before { do_request(access_token: access_token.token) }

      it_behaves_like "API Successful request"
      it_behaves_like "API Included objects", 'returns list of answers', 2, 'answers'
      it_behaves_like "API Contains attributes", 'answer', 'answers/0/'
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:comment) { create :comment, commentable: answer }
      let!(:attachment) { create :attachment, attachable: answer }

      before { do_request(access_token: access_token.token) }

      it_behaves_like "API Successful request"
      it_behaves_like "API Contains attributes", 'answer', 'answer/'
      it_behaves_like "API Commentable"
      it_behaves_like "API Attachable"
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like "API Authenticable"
    it_behaves_like "API Create object", Answer

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end
end
