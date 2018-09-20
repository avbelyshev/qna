require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  describe 'vkontakte' do
    let!(:user) { create :user, email: 'user@qna.com' }

    before do
      request.env['devise.mapping'] = Devise.mappings[:user]
      request.env['omniauth.auth'] = mock_auth_hash
      get :vkontakte
    end

    it 'redirects to root path' do
      expect(response).to redirect_to(root_path)
    end

    it 'returns user' do
      expect(subject.current_user).to eq(user)
    end

    it 'should set flash message' do
      expect(controller).to set_flash[:notice]
    end
  end
end
