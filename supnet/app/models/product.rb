class Product < ApplicationRecord
  validates_presence_of :status, :company_name, :company_ids, :product_description, :product_ids, :product_category_cpc, :product_name_company, :pcf_declared_unit, :pcf_unitary_product_amount, :pcf_fossil_ghg_emissions

  has_many :sources
  has_many :nodes, through: :sources

  attribute :version, :integer, default: "1"

  REGIONS = ["Africa", "Americas", "Asia", "Europe", "Oceania", "Australia and New Zealand", "Central Asia", "Eastern Asia", "Eastern Europe", "Latin America and the Caribbean", "Melanesia", "Micronesia", "Northern Africa", "Northern America", "Northern Europe", "Polynesia", "South-eastern Asia", "Southern Asia", "Southern Europe", "Sub-Saharan Africa", "Western Asia", "Western Europe"]

end