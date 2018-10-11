shared_examples_for "API Create object" do |model|
  context 'authorized' do
    let(:user) { User.find(access_token.resource_owner_id) }

    context 'with valid attributes' do
      let(:post_object) { do_request(question: attributes_for(:question), access_token: access_token.token) } if model == Question
      let(:post_object) { do_request(answer: attributes_for(:answer), access_token: access_token.token) } if model == Answer

      it 'returns 201 status code' do
        post_object
        expect(response).to be_successful
      end

      it "saves a new user's #{model.to_s.downcase} in the database" do
        expect { post_object }.to change(user.send(model.to_s.downcase.pluralize.to_sym), :count).by(1)
      end
    end

    context 'with invalid attributes' do
      let(:post_invalid_object) { do_request(question: attributes_for(:invalid_question), access_token: access_token.token) } if model == Question
      let(:post_invalid_object) { do_request(answer: attributes_for(:invalid_answer), access_token: access_token.token) } if model == Answer

      it 'returns 422 status code' do
        post_invalid_object
        expect(response.status).to eq 422
      end

      it "does not save the #{model.to_s.downcase}" do
        expect { post_invalid_object }.to_not change(model, :count)
      end
    end
  end
end
