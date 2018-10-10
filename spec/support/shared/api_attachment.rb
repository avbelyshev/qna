shared_examples_for "API Attachable" do
  context 'attachments' do
    it 'included in object' do
      expect(response.body).to have_json_size(1).at_path("#{type}/attachments")
    end

    it 'attachment object contains file_url' do
      expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("#{type}/attachments/0/file_url")
    end
  end
end
