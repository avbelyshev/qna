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

  describe 'DELETE #destroy' do
    sign_in_user

    let!(:users_answer) { create(:answer, question: question, user: @user) }

    context 'User tries to delete his answer' do
      before { users_answer }

      it 'deletes answer' do
        expect { delete :destroy, params: { question_id: question, id: users_answer } }.to change(question.answers, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { question_id: question, id: users_answer }
        expect(response).to redirect_to question_path(users_answer.question)
      end
    end

    context 'User tries to delete not his answer' do
      before { sign_in(create(:user)) }

      it 'does not delete answer' do
        expect { delete :destroy, params: { question_id: question, id: users_answer } }.to_not change(question.answers, :count)
      end
    end
  end
end
