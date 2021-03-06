require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:comment) { create(:comment, commentable: question, user: user) }

  describe 'POST #create' do
    before { sign_in(user) }

    context 'with valid attributes' do
      it 'saves a new user\'s comment in database' do
        expect { post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js }.
            to change(user.comments, :count).by(1)
      end

      it 'saves a new question\'s comment in database' do
        expect { post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js }.
            to change(question.comments, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the comment' do
        expect { post :create, params: { comment: attributes_for(:invalid_comment), question_id: question }, format: :js }.
            to_not change(question.comments, :count)
      end

      it 'render create template' do
        post :create, params: { comment: attributes_for(:invalid_comment), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in(user) }

    context 'User tries to update his comment with valid attributes' do
      it 'assigns the requested comment to @comment' do
        patch :update, params: { id: comment, comment: attributes_for(:comment) }, format: :js
        expect(assigns(:comment)).to eq comment
      end

      it 'changes comment attributes' do
        patch :update, params: { id: comment, comment: { body: 'new body' } }, format: :js
        comment.reload
        expect(comment.body).to eq 'new body'
      end

      it 'renders update template' do
        patch :update, params: { id: comment, comment: attributes_for(:comment) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'User tries to update his comment with invalid attributes' do
      let(:old_comment) { comment }
      before { patch :update, params: { id: comment, comment: { body: '' } }, format: :js}

      it 'does not changes comment attributes' do
        comment.reload
        expect(comment.body).to eq old_comment.body
      end

      it 'renders update template' do
        expect(response).to render_template :update
      end
    end

    context 'User tries to update not his comment' do
      before { sign_in(another_user) }

      it 'does not change comment attributes' do
        old_body = comment.body
        patch :update, params: { id: comment, comment: { body: 'new body' } }, format: :js
        comment.reload
        expect(comment.body).to eq old_body
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'User tries to delete his comment' do
      before { sign_in(user) }

      it 'deletes comment' do
        expect { delete :destroy, params: { id: comment }, format: :js }.to change(question.comments, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: comment }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'User tries to delete not his comment' do
      before { sign_in(another_user) }

      it 'does not delete comment' do
        expect { delete :destroy, params: { id: comment }, format: :js }.to_not change(question.comments, :count)
      end
    end
  end
end
