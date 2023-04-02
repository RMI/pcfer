class Product < ApplicationRecord
  validates_presence_of :status, :company_name, :company_ids, :product_description, :product_ids, :product_category_cpc, :product_name_company, :pcf_declared_unit, :pcf_unitary_product_amount, :pcf_fossil_ghg_emissions
  REGIONS = ["Africa", "Americas", "Asia", "Europe", "Oceania", "Australia and New Zealand", "Central Asia", "Eastern Asia", "Eastern Europe", "Latin America and the Caribbean", "Melanesia", "Micronesia", "Northern Africa", "Northern America", "Northern Europe", "Polynesia", "South-eastern Asia", "Southern Asia", "Southern Europe", "Sub-Saharan Africa", "Western Asia", "Western Europe"]

  belongs_to :vendor, optional: true

  scope :yours, -> { where("vendor_id IS NULL") }
  scope :received, -> { where("vendor_id IS NOT NULL") }
  scope :parents, -> { where.not(preceding_pf_ids: []) }

  scope :active, -> { where("status = 'Active'")}

  # scope :comments, where("text_value <> ''")

  attribute :version, :integer, default: "1"

  def company_and_product_name
    "#{self.company_name}, #{self.product_name_company}"
  end

  # When sending PCFs, id on the sending side needs to become orginal_id on the
  # receiving side, so you can trace backwards. Do it before sending.
  # TODO: can this be moved to the receiving side, but setting original_id from
  # id before the product is saved?
  def switch_ids
    self.original_id = self.id
    self.id = nil
    self
  end

  # For sending product data via json API. Also recursively sends child PCFs
  def send_pcf( customer_id )
    if customer = Customer.find(customer_id)

      headers = {
        "Content-Type": "application/json",
        "X-API-Key": "#{customer.api_key}"
      }

      # switch_ids is going to zap this product's ID, so that it doesn't
      # mess with the ID on the receiving side, so set it to another variable
      # so it can be used below
      id_of_original_product_being_sent = self.id

      HTTParty.post(  customer.api_endpoint,
                      body: self.switch_ids.to_pact.to_json,
                      headers: headers)

      # Check if there are preceding PCFs, then send those.
      if self.preceding_pf_ids.present?

        self.preceding_pf_ids.each do |pid|
          if preceding_product = Product.find(pid)
            # the preceding product's parent id should be set to the one being sent...
            preceding_product.parent_id = id_of_original_product_being_sent
            preceding_product.save

            # then the preceding product should be sent as well.
            preceding_product.send_pcf(customer_id)
          end
        end
      end

    end
  end

  def to_pact
    out={}
    pcf={}
    dqi={}
    assurance={}

    # TODO: this now has a few non-pact fields, need to handle that. Add
    # an input to this method, something like 'include_non_pact', maybe

    # go through fields, fill in the nested parts
    self.attributes.each do |attribute|
      if attribute[0].include?("pcf_dqi_")
        dqi[attribute[0].delete_prefix("pcf_dqi_")] = attribute[1]
      elsif attribute[0].include?("pcf_assurance_")
        assurance[attribute[0].delete_prefix("pcf_assurance_")] = attribute[1]
      elsif attribute[0].include?("pcf_")
        pcf[attribute[0].delete_prefix("pcf_")] = attribute[1]
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