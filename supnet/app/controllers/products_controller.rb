class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show send_pcf edit update destroy ]
  skip_before_action :verify_authenticity_token

  # GET /products or /products.json
  def index
    @title = "PCFs"

    @products = case
    when params[:yours]
      @whose = "Your"
      Product.yours
    when params[:received]
      @whose = "Received"
      Product.received
    else
      Product.all
    end
  end

  # GET /products/1 or /products/1.json
  def show
    @title = "PCF"
    respond_to do |format|
      format.html { render :show }
      format.json do

        # THIS should be DRYed up-----
        @top={}
        @pcf={}
        @dqi={}
        @assurance={}
        # go through fields, fill in the nested parts
        @product.attributes.each do |attribute|
          if attribute[0].include?("pcf_dqi_")
            @dqi[attribute[0]] = attribute[1]
          elsif attribute[0].include?("pcf_assurance_")
            @assurance[attribute[0]] = attribute[1]
          elsif attribute[0].include?("pcf_")
            @pcf[attribute[0]] = attribute[1]
          else
            @top[attribute[0]] = attribute[1]
          end
        end
        # -----------------------------

        # then output json that reflects the proper pact, instead of the rails object

        render "products/pact"
      end
    end
  end

  #   send_product(product) is the route to
  #   send_product POST   /products/:id/send(.:format)     products#send
  #   include customer_id and api_key in header
  def send_pcf
    respond_to do |format|
      format.html { render :show }
      format.json do
        logger.debug "-----------> hit it!"
        # you've got the product
        logger.debug "-----------> Product is: #{@product.company_name}"
        @customer = Customer.find(params[:customer_id])
        logger.debug "-----------> Customer is: #{@customer.name}"
        logger.debug "-----------> Customer endpoint: #{@customer.api_endpoint}"
        logger.debug "-----------> Customer key: #{@customer.api_key}"

        uri = URI( @customer.api_endpoint )

        logger.debug uri.scheme
        # #=> "http"
        logger.debug uri.host
        # #=> "foo.com"
        logger.debug uri.path
        # #=> "/posts"
        # uri.query
        # #=> "id=30&limit=5"
        # uri.fragment
        # #=> "time=1305298413"
        # uri.to_s
        # #=> "http://foo.com/posts?id=30&limit=5#time=1305298413"
        logger.debug uri.port

        # serialize the product, send to endpoint via Faraday
        conn = Faraday.new(
          url: "#{uri.scheme}://#{uri.host}:#{uri.port}",
          headers: {"Content-Type": "application/json", "X-API-Key": "#{@customer.api_key}"}
        )
        logger.debug "created faraday connection"

        response = conn.post( uri.path ) do |req|
          req.body = @product.to_json
        end

      end
    end
  end

  # GET /products/new
  def new
    @title = "New PCF"
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
    @title = "Edit PCF"
  end

  # POST /products or /products.json
  def create
    logger.debug "--------------> JUST HIT CREATE"
    logger.debug "-------> X-API-Key: #{request.headers["X-API-Key"]}"
    # logger.debug "-------> all the params: #{params.to_unsafe_h}"

    respond_to do |format|
      format.html {
        @product = Product.new(product_params)
      }

      format.json {
        logger.debug "------- in json"
        @product = Product.new

        if request.headers.include?("X-API-Key")
          logger.debug "-------> got key"
          if vendors = Vendor.where( "api_key = ?", request.headers["X-API-Key"] )
            logger.debug "-------> got vendors"
            logger.debug "-------> which is: #{vendors.first.inspect}"
            @product.vendor = vendors.first
          else
            logger.debug "could not find vendor"
            return 401
          end
        else
          logger.debug "Missing API key for POSTED PCF info"
          return 401
        end
        logger.debug "product vendor is: #{@product.vendor.inspect}"

        # go through pact-format post params and convert to the rails model attributes
        # DRY this up?
        request.POST.each do |param|
          if param[0] == "pcf"
            logger.debug "--> processing #{param[0]}"
            pcf_params = param[1]{}
            pcf_params.each do |pcf_param|
              if pcf_param[0] == "dqi"
                dqi_params = pcf_param[1]
                dqi_params.each do |dqi_param|
                  @product.public_send("pcf_dqi_#{dqi_param[0]}=", dqi_param[1])
                end
              elsif pcf_param[0] == "assurance"
                ass_params = pcf_param[1]
                ass_params.each do |ass_param|
                  @product.public_send("pcf_assurance_#{ass_param[0]}=", ass_param[1])
                end
              else
                @product.public_send("pcf_#{pcf_param[0]}=", pcf_param[1])
              end
            end
          else
            # else, call the method on the model with the matching name. unless it's "product," I'm not sure why that's even in there.
            unless param[0] == "product"
              @product.public_send("#{param[0]}=", param[1])
            end
          end
        end
        logger.debug "---------> done with params"
      } # end format.json block
    end

    respond_to do |format|
      logger.debug "about to save"
      logger.debug "------> product: #{@product.inspect}"
      if @product.save
        logger.debug "---------> saved product"
        format.html {
          redirect_to product_url(@product), notice: "Product was successfully created." }
        format.json {
          logger.debug "---------> about to render product. why is location the product?"
          render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(
        :original_id, :vendor_id, :spec_version, :preceding_pf_ids, :version,
        :created, :updated, :status, :status_comment,
        :validity_period_start, :validity_period_end,
        :company_name, :company_ids, :product_description,
        :product_ids, :product_category_cpc, :product_name_company,
        :comment, :pcf_declared_unit, :pcf_unitary_product_amount,
        :pcf_pcf_excluding_biogenic, :pcf_pcf_including_biogenic,
        :pcf_fossil_ghg_emissions, :pcf_fossil_carbon_content,
        :pcf_biogenic_carbon_content, :pcf_d_luc_ghg_emissions,
        :pcf_land_management_ghg_emissions, :pcf_other_biogenic_ghg_emissions,
        :pcf_i_luc_ghg_emissions, :pcf_biogenic_carbon_withdrawal,
        :pcf_aircraft_ghg_emissions, :pcf_characterization_factors,
        :pcf_biogenic_accounting_methodology, :pcf_boundary_processes_description,
        :pcf_reference_period_start, :pcf_reference_period_end, :pcf_geography_country_subdivision,
        :pcf_geography_country, :pcf_geography_region_or_subregion, :pcf_secondary_emission_factor_sources,
        :pcf_exempted_emissions_percent, :pcf_exempted_emissions_description,
        :pcf_packaging_emissions_included, :pcf_packaging_ghg_emissions,
        :pcf_allocation_rules_description, :pcf_uncertainty_assessment_description,
        :pcf_primary_data_share, :pcf_allocation_rules_description, :pcf_uncertainty_assessment_description,
        :pcf_dqi_coverage_percent, :pcf_dqi_technological_dqr, :pcf_dqi_temporal_dqr,
        :pcf_dqi_geographical_dqr, :pcf_dqi_completeness_dqr, :pcf_dqi_reliability_dqr,
        :pcf_assurance_coverage, :pcf_assurance_level, :pcf_assurance_boundary, :pcf_assurance_provider_name,
        :pcf_assurance_completed_at, :pcf_assurance_standard_name, :pcf_assurance_comments, :extensions,
        pcf_cross_sectoral_standards_used: [], pcf_product_or_sector_specific_rules: []
      )
    end
end
