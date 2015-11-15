json.array!(@records) do |record|
  json.extract! record, :id, :rating, :count, :want, :discogs_id, :title, :uri
  json.url record_url(record, format: :json)
end
