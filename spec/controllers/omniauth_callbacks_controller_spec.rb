require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let!(:user) { create :user, email: 'user@qna.com' }
  before { request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'vkontakte' do
    before do
      request.env['omniauth.auth'] = mock_auth_hash_vkontakte
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

  describe 'github' do
    before do
      request.env['omniauth.auth'] = mock_auth_hash_github
      get :github
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
