json.array!(@queries) do |query|
  json.extract! query, :id, :query_string, :total_pages, :completed_page
  json.url query_url(query, format: :json)
end
