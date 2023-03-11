json.extract! customer, :id, :name, :email, :description, :api_endpoint, :api_key, :created_at, :updated_at
json.url customer_url(customer, format: :json)
