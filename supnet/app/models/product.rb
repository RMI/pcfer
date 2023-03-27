class Product < ApplicationRecord
  validates_presence_of :status, :company_name, :company_ids, :product_description, :product_ids, :product_category_cpc, :product_name_company, :pcf_declared_unit, :pcf_unitary_product_amount, :pcf_fossil_ghg_emissions
  REGIONS = ["Africa", "Americas", "Asia", "Europe", "Oceania", "Australia and New Zealand", "Central Asia", "Eastern Asia", "Eastern Europe", "Latin America and the Caribbean", "Melanesia", "Micronesia", "Northern Africa", "Northern America", "Northern Europe", "Polynesia", "South-eastern Asia", "Southern Asia", "Southern Europe", "Sub-Saharan Africa", "Western Asia", "Western Europe"]

  belongs_to :vendor, optional: true

  scope :yours, -> { where("vendor_id IS NULL") }
  scope :received, -> { where("vendor_id IS NOT NULL") }
  scope :active, -> { where("status = 'Active'")}

  attribute :version, :integer, default: "1"

  def company_and_product_name
    "#{self.company_name}, #{self.product_name_company}"
  end

  def switch_ids
    # Trying to fix mixed-up IDs
    self.original_id = self.id
    self.id = nil
    self
  end

  # def send_pcf( customer_id, original_parent_id )
  def send_pcf( customer_id )
    if customer = Customer.find(customer_id)

      headers = {
        "Content-Type": "application/json",
        "X-API-Key": "#{customer.api_key}"
      }

      HTTParty.post(  customer.api_endpoint,
                      body: self.switch_ids.to_pact.to_json,
                      headers: headers)

      # Check if there are preceding PCFs, then send those. Until you fix it,
      # All the preceding_pf_ids on the receiving side will be wrong, since
      # they'll refer to IDs on the sending system. So once you've sent
      # everything over, send a message saying to rectify everything over there
      if self.preceding_pf_ids.present?
        self.preceding_pf_ids.each do |pid|
          if preceding_product = Product.find(pid)
            preceding_product.send_pcf(customer_id)
          end
        end
      end

      # Tell the main pcf you sent to fix the preceding ids
      # self.fix_precedings
      # 0. Send the id/original_id, and its preceding_id's, to a rectification method
      # 1. search on the other side for a product with an original_id that matches
      # this current id.
      # 2. get the set of products whose original_id matches the ids in the preceeding_id set
      # 3. replace the preceeding_ids with the new set you just gathered.

    end
  end

  # # this returns a URL matching the PCFer API, so is only sure to work if the
  # # vendor is running PCFer. Ignore this inconvenience for now.
  # def vendor_url_with_key
  #   if self.vendor_id.present?
  #     logger.debug "--------> vendor_id: #{self.vendor_id}"
  #     vendor = Vendor.find(self.vendor_id)
  #     logger.debug "--------> vendor: #{vendor.name}"
  #     # A product URL http://seller:3030/products/61afd55a-8d67-43f5-b53e-6181270d194a.json
  #     # Vendor API endpoint http://host.docker.internal:3000/products.json
  #     # Vendor API key: sk_TJz18wWFQC_3JhqHKjnI6A

  #     # uri = URI("http://foo.com/posts?id=30&limit=5#time=1305298413")
  #     # uri.scheme
  #     # #=> "http"
  #     # uri.host
  #     # #=> "foo.com"
  #     # uri.path
  #     # #=> "/posts"
  #     # uri.query
  #     # #=> "id=30&limit=5"
  #     # uri.fragment
  #     # #=> "time=1305298413"
  #     logger.debug "-------> vendor api endpoint: #{vendor.api_endpoint}"
  #     uri = URI(vendor.api_endpoint)
  #     "#{uri.scheme}://#{uri.host}:#{uri.port}/products/#{self.id}.json"
  #   else
  #     nil
  #   end
  # end

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