require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:model) { described_class }
  let(:resource) { create(model.to_s.underscore.to_sym) }

  describe '#set_like!' do
    it 'should add vote to resource' do
      expect { resource.set_like!(user) }.to change(resource.votes, :count).by(1)
    end

    it 'should change rating of resource' do
      resource.set_like!(user)
      expect(resource.rating).to eq 1
    end

    it 'should don\'t add vote to resource if user has already voted' do
      resource.set_like!(user)
      expect { resource.set_like!(user) }.to_not change(resource.votes, :count)
    end

    it 'should don\'t add vote to resource if user is an author' do
      expect { resource.set_like!(resource.user) }.to_not change(resource.votes, :count)
    end
  end

  describe '#set_dislike!' do
    it 'should add vote to resource' do
      expect { resource.set_dislike!(user) }.to change(resource.votes, :count).by(1)
    end

    it 'should change rating of resource' do
      resource.set_dislike!(user)
      expect(resource.rating).to eq -1
    end

    it 'should don\'t add vote to resource if user has already voted' do
      resource.set_dislike!(user)
      expect { resource.set_dislike!(user) }.to_not change(resource.votes, :count)
    end

    it 'should don\'t add vote to resource if user is an author' do
      expect { resource.set_dislike!(resource.user) }.to_not change(resource.votes, :count)
    end
  end

  describe '#cancel_vote!' do
    it 'should remove user\'s votes from resource' do
      resource.set_like!(user)
      expect { resource.cancel_vote!(user) }.to change(resource.votes, :count).by(-1)
    end
  end
end
