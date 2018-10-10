require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:me) { create(:user) }
      subject { me }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { do_request(access_token: access_token.token) }

      it_behaves_like "API Successful request"
      it_behaves_like "API Contains attributes", 'user'

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:profiles) { create_list(:user, 3) }
      let(:profile) { profiles.first }
      subject { profile }

      before { do_request(access_token: access_token.token) }

      it_behaves_like "API Successful request"
      it_behaves_like "API Contains attributes", 'user', '0/'

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path("0/#{attr}")
        end
      end

      it 'does not include me' do
        expect(response.body).to_not include_json(me.to_json)
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/', params: { format: :json }.merge(options)
    end
  end
end
