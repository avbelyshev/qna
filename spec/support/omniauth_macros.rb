module OmniauthMacros
  def mock_auth_hash
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new(
      provider: 'vkontakte',
      uid: '123456',
      info: { email: 'user@qna.com' }
    )
  end
end
