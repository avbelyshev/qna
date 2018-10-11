require 'rails_helper'

describe 'Questions API' do
  let(:access_token) { create(:access_token) }
  let!(:questions) { create_list(:question, 2) }
  let(:question) { questions.first }
  subject { question }
  let(:type) { question.class.name.downcase }
  let!(:answer) { create(:answer, question: question) }

  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      before { do_request(access_token: access_token.token) }

      it_behaves_like "API Successful request"
      it_behaves_like "API Included objects", 'returns list of questions', 2, 'questions'
      it_behaves_like "API Contains attributes", 'question', 'questions/0/'

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("questions/0/short_title")
      end

      context 'answers' do
        subject { answer }
        it_behaves_like "API Included objects", 'included in question object', 1, 'questions/0/answers'
        it_behaves_like "API Contains attributes", 'answer', 'questions/0/answers/0/'
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:comment) { create :comment, commentable: question }
      let!(:attachment) { create :attachment, attachable: question }

      before { do_request(access_token: access_token.token) }

      it_behaves_like "API Successful request"
      it_behaves_like "API Contains attributes", 'question', 'question/'

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("question/short_title")
      end

      context 'answers' do
        subject { answer }
        it_behaves_like "API Included objects", 'included in question object', 1, 'question/answers'
        it_behaves_like "API Contains attributes", 'answer', 'question/answers/0/'
      end

      it_behaves_like "API Commentable"
      it_behaves_like "API Attachable"
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like "API Authenticable"
    it_behaves_like "API Create object", Question

    def do_request(options = {})
      post '/api/v1/questions/', params: { format: :json }.merge(options)
    end
  end
end
