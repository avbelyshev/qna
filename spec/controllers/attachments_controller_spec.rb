require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:attachment) { create(:attachment, attachable: question) }

  describe 'DELETE #destroy' do
    context 'User tries to delete attachment to his question' do
      before { sign_in(user) }

      it 'deletes attachment' do
        expect { delete :destroy, params: { id: attachment }, format: :js }.to change(question.attachments, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: attachment }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'User tries to delete attachment to not his question' do
      before { sign_in(create(:user)) }

      it 'does not delete answer' do
        expect { delete :destroy, params: { id: attachment }, format: :js }.to_not change(question.answers, :count)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: attachment }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
