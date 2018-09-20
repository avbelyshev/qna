module OmniauthMacros
  def mock_auth_hash_vkontakte
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new(
      provider: 'vkontakte',
      uid: '123456',
      info: { email: 'user@qna.com' }
    )
  end

  def mock_auth_hash_github
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
        provider: 'github',
        uid: '123456',
        info: { email: 'user@qna.com' }
    )
  end
end
