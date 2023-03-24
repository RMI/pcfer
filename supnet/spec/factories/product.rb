FactoryBot.define do
  factory :product do
    sequence(:id) { |n| n }
    status { "Active" }
    created { Time.now }
    company_name { "Acme Aluminum" }
    company_ids { "123" }
    product_description { "prod desc" }
    product_ids { "456" }
    product_category_cpc { "3120" }
    product_name_company { "finest rolled aluminum" }
    pcf_declared_unit { "kilogram" }
    pcf_unitary_product_amount { "5" }
    pcf_fossil_ghg_emissions { "5" }
  end
end
