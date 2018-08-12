require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    before { sign_in(user) }
    
    context 'with valid attributes' do
      it 'saves a new user\'s answer in database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js } }.
        to change(user.answers, :count).by(1)
      end

      it 'saves a new question\'s answer in database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js } }.
        to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js } }.
        to_not change(question.answers, :count)
      end

      it 'render create template' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    let!(:answer) { create(:answer, question: question, user: @user) }

    it 'assigns the requested answer to @answer' do
      patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'changes answer attributes' do
      patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it 'renders update template' do
      patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    let!(:users_answer) { create(:answer, question: question, user: @user) }

    context 'User tries to delete his answer' do
      before { users_answer }

      it 'deletes answer' do
        expect { delete :destroy, params: { id: users_answer } }.to change(question.answers, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: users_answer }
        expect(response).to redirect_to question_path(users_answer.question)
      end
    end

    context 'User tries to delete not his answer' do
      before { sign_in(create(:user)) }

      it 'does not delete answer' do
        expect { delete :destroy, params: { id: users_answer } }.to_not change(question.answers, :count)
      end

      it 'redirects to question\'s show view' do
        delete :destroy, params: { id: users_answer }
        expect(response).to redirect_to question
      end
    end
  end
end
