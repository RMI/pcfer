json.extract! node, :id, :owner, :category, :subcategory, :url, :api_key, :created_at, :updated_at
json.url node_url(node, format: :json)
