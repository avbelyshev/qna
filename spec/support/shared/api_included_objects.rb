shared_examples_for "API Included objects" do |example_name, size, path = ''|
  it "#{example_name}" do
    expect(response.body).to have_json_size(size).at_path(path)
  end
end
