shared_examples_for "API Commentable" do
  context 'comments' do
    it 'included in object' do
      expect(response.body).to have_json_size(1).at_path("#{type}/comments")
    end

    subject { comment }
    it_behaves_like "API Contains attributes", 'comment'
  end
end
