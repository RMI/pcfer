json.extract! node, :id, :owner, :category, :subcategory, :url, :created_at, :updated_at
json.url node_url(node, format: :json)
