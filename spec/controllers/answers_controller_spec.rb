require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { sign_in(user) }
    
    context 'with valid attributes' do
      it 'saves a new user\'s answer in database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.
        to change(user.answers, :count).by(1)
      end

      it 'saves a new question\'s answer in database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.
        to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }, format: :js }.
        to_not change(question.answers, :count)
      end

      it 'render create template' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in(user) }

    context 'User tries to update his answer with valid attributes' do
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

    context 'User tries to update his answer with invalid attributes' do
      let(:old_answer) { answer }
      before { patch :update, params: { id: answer, answer: { body: '' } }, format: :js}

      it 'does not changes answer attributes' do
        answer.reload
        expect(answer.body).to eq old_answer.body
      end

      it 'renders update template' do
        expect(response).to render_template :update
      end
    end

    context 'User tries to update not his answer' do
      before { sign_in(create(:user)) }

      it 'does not change answer attributes' do
        old_body = answer.body
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq old_body
      end
    end
  end

  describe 'PATCH #set_best' do
    context 'User tries to choose answer for his question as the best' do
      before { sign_in(user) }

      it 'chooses the answer as the best' do
        patch :set_best, params: { id: answer }, format: :js
        answer.reload
        expect(answer).to be_best
      end
    end

    context 'User tries to choose answer for not his question as the best' do
      before { sign_in(create(:user)) }

      it 'does not chooses the answer as the best' do
        patch :set_best, params: { id: answer }, format: :js
        answer.reload
        expect(answer).not_to be_best
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'User tries to delete his answer' do
      before { sign_in(user) }

      it 'deletes answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(question.answers, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'User tries to delete not his answer' do
      before { sign_in(create(:user)) }

      it 'does not delete answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(question.answers, :count)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
