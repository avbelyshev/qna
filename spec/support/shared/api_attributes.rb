shared_examples_for "API Contains attributes" do |type, path_part = ''|
  attributes = nil
  attributes = %w(id title body created_at updated_at user_id) if type == 'question'
  attributes = %w(id question_id body created_at updated_at user_id best) if type == 'answer'
  attributes = %w(id user_id body created_at updated_at) if type == 'comment'
  attributes = %w(id email created_at updated_at admin) if type == 'user'

  attributes.each do |attr|
    it "#{type} object contains #{attr}" do
      path_part = "#{subject.commentable_type.downcase}/comments/0/" if type == 'comment'
      expect(response.body).to be_json_eql(subject.send(attr.to_sym).to_json).at_path("#{path_part}#{attr}")
    end
  end
end
