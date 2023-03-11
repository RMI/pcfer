class Product < ApplicationRecord
  validates_presence_of :status, :company_name, :company_ids, :product_description, :product_ids, :product_category_cpc, :product_name_company, :pcf_declared_unit, :pcf_unitary_product_amount, :pcf_fossil_ghg_emissions

  REGIONS = ["Africa", "Americas", "Asia", "Europe", "Oceania", "Australia and New Zealand", "Central Asia", "Eastern Asia", "Eastern Europe", "Latin America and the Caribbean", "Melanesia", "Micronesia", "Northern Africa", "Northern America", "Northern Europe", "Polynesia", "South-eastern Asia", "Southern Asia", "Southern Europe", "Sub-Saharan Africa", "Western Asia", "Western Europe"]

  belongs_to :vendor, optional: true
  # has_many :sources
  # has_many :nodes, through: :sources

  scope :yours, -> { where("vendor_id IS NULL") }
  scope :received, -> { where("vendor_id IS NOT NULL") }
  scope :active, -> { where("status = 'Active'")}

  attribute :version, :integer, default: "1"

  def company_and_product_name
    "#{self.company_name}, #{self.product_name_company}"
  end

  def to_pact
    self.original_id = self.id
    self.id = nil
    out={}
    pcf={}
    dqi={}
    assurance={}

    # go through fields, fill in the nested parts
    self.attributes.each do |attribute|
      if attribute[0].include?("pcf_dqi_")
        dqi[attribute[0]] = attribute[1]
      elsif attribute[0].include?("pcf_assurance_")
        assurance[attribute[0]] = attribute[1]
      elsif attribute[0].include?("pcf_")
        pcf[attribute[0]] = attribute[1]
      else
        out[attribute[0]] = attribute[1]
      end
    end
    pcf[:dqi] = dqi
    pcf[:assurance] = assurance
    out[:pcf] = pcf
    out
  end


end