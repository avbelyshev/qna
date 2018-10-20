class Search
  SEARCH_OBJECTS = %w(All Questions Answers Comments Users)

  def self.search_results(search_text, search_object)
    query_escape = ThinkingSphinx::Query.escape(search_text)
    return ThinkingSphinx.search query_escape if search_object == 'All' || search_object.empty?
    search_object.singularize.constantize.search query_escape
  end
end
