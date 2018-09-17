require 'rails_helper'

shared_examples_for 'voted' do
  let(:controller) { described_class }
  let(:resource) { create(controller.to_s.underscore.split('_')[0].singularize.to_sym) }
  let!(:user) { create(:user) }

  before { sign_in(user) }

  describe 'PATCH #set_like' do
    it 'saves a new resource\'s vote in the database' do
      expect { patch :set_like, params: { id: resource.id, format: :json } }.to change(resource.votes, :count).by(1)
    end

    context 'response' do
      before { patch :set_like, params: { id: resource.id, format: :json } }

      it 'gets success json response' do
        expect(response.status).to eq 200
        expect(response.header['Content-Type']).to include 'application/json'
        expect(response.body).to eq "{\"id\":#{resource.id},\"rating\":1}"
      end

      it 'returns forbidden status for revote' do
        patch :set_like, params: { id: resource.id, format: :json }
        expect(response.status).to eq 403
        expect(response.header['Content-Type']).to include 'application/json'
      end
    end
  end

  describe 'PATCH #set_dislike' do
    it 'saves a new resource\'s vote in the database' do
      expect { patch :set_dislike, params: { id: resource.id, format: :json } }.to change(resource.votes, :count).by(1)
    end

    context 'response' do
      before { patch :set_dislike, params: { id: resource.id, format: :json } }

      it 'gets success json response' do
        expect(response.status).to eq 200
        expect(response.header['Content-Type']).to include 'application/json'
        expect(response.body).to eq "{\"id\":#{resource.id},\"rating\":-1}"
      end

      it 'returns forbidden status for revote' do
        patch :set_dislike, params: { id: resource.id, format: :json }
        expect(response.status).to eq 403
        expect(response.header['Content-Type']).to include 'application/json'
      end
    end
  end

  describe 'PATCH #cancel_vote' do
    it 'deletes resource\'s vote from the database' do
      patch :set_like, params: { id: resource.id, format: :json }
      expect { patch :cancel_vote, params: { id: resource.id } }.to change(resource.votes, :count).by(-1)
    end

    context 'response' do
      it 'gets success json response' do
        patch :set_like, params: { id: resource.id, format: :json }
        patch :cancel_vote, params: { id: resource.id, format: :json }
        expect(response.status).to eq 200
        expect(response.header['Content-Type']).to include 'application/json'
        expect(response.body).to eq "{\"id\":#{resource.id},\"rating\":0}"
      end

      it 'returns forbidden status if resource don\'t have votes' do
        patch :cancel_vote, params: { id: resource.id, format: :json }
        expect(response.status).to eq 403
        expect(response.header['Content-Type']).to include 'application/json'
      end
    end
  end
end
