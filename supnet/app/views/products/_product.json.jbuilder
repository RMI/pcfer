json.extract! product, :id, :volume, :unit, :category, :subcategory, :location, :vendor, :carbon_intensity, :produced_at, :created_at, :updated_at
json.url product_url(product, format: :json)
