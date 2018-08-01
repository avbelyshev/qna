require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    before { sign_in(user) }
    
    context 'with valid attributes' do
      it 'saves a new answer in database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.
        to change(question.answers, :count).by(1)
      end

      it 'redirect to question show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question } }.
        to_not change(question.answers, :count)
      end

      it 're-renders question show view' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }
        expect(response).to render_template 'questions/show'
      end
    end
  end
end
