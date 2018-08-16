require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2, user: user) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'builds new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves a new user\'s question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(@user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    let(:question) { create(:question, user: @user) }

    context 'valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'render updated template' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'invalid attributes' do
      let(:old_question) { question }
      before { patch :update, params: { id: question, question: { title: 'new title', body: nil } }, format: :js }

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq old_question.title
        expect(question.body).to eq old_question.body
      end

      it 'render updated template' do
        expect(response).to render_template :update
      end
    end

    context 'User tries to update not his question' do
      before { sign_in(create(:user)) }

      it 'does not change question attributes' do
        old_body = question.body
        patch :update, params: { id: question, question: { body: 'new body' } }, format: :js
        question.reload
        expect(question.body).to eq old_body
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    let(:users_question) { create(:question, user: @user) }

    context 'User tries to delete his question' do
      before { users_question }

      it 'deletes question' do
        expect { delete :destroy, params: { id: users_question } }.to change(@user.questions, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: users_question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'User tries to delete not his question' do
      before { question }

      it 'does not delete question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to question\'s show view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to question
      end
    end
  end
end
