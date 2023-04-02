class ProductsController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_product, only: %i[ show send_pcf edit update destroy ]
  skip_before_action :verify_authenticity_token

  # GET /products or /products.json
  def index
    authenticate_user!
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
      format.html {
        authenticate_user!
        render :show
      }
      format.json do
        render "products/pact"
      end
    end
  end

  def send_pcf
    respond_to do |format|
      format.html { render :show }
      format.json do
        @product.send_pcf(params[:customer_id])
      end
    end
  end

  # GET /products/new
  def new
    authenticate_user!

    @title = "New PCF"
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
    @title = "Edit PCF"
  end

  # set original_id on the sending side, bc that's where it's known
  # keep parent_id the same when sending, then set RE-set the parent_id on the receiving side
  # then on receiving side:
  # - if there's a parent_id from the sender, get the parent product on the receiving end
  #   using find_by_original_id( parent_id )
  # - reset parent_id on the receiving end to the value returned by find_by_original_id
  # -
  # QUESTION: does the existence of parent_id negate the need for preceeding_pfid? That would
  # actually be good since preceeding_pfid has another meaning in the pact docs.
  # Actually it's needed for the form, but might want to move that to something in
  # the traceabilityi extension, so we're not misusing that.
  # POST /products or /products.json
  def create
    respond_to do |format|
      format.html {
        @product = Product.new(product_params)
      }

      format.json {

        # Validate the API key, return if you can't
        if request.headers.include?("X-API-Key")
          # Get the vendor by unique API key and attach to the Product
          if vendors = Vendor.where("api_key = ?", request.headers["X-API-Key"])
            @product = Product.new
            @product.vendor = vendors.first
          else
            logger.debug "could not find vendor"
            return 401
          end
        else
          logger.debug "Missing API key for POSTED PCF info"
          return 401
        end

        # Go through pact-format post params and convert to the rails model
        # attributes. DRY this up?

        # Data coming in via API will be in nested PACT format, but it needs to be saved
        # in flat fields corresponding to the Rails model attributes, so we iterate through
        # the PACT-format params, and flatten by namespace (pcf, dqi, assurance)
        request.POST.each do |param|
          # deal with evereything under pcf
          if param[0] == "pcf"
            pcf_params = param[1]{}
            pcf_params.each do |pcf_param|

              # deal with dqi
              if pcf_param[0] == "dqi"
                dqi_params = pcf_param[1]
                dqi_params.each do |dqi_param|
                  @product.public_send("pcf_dqi_#{dqi_param[0]}=", dqi_param[1])
                end

              # deal with assurance
              elsif pcf_param[0] == "assurance"
                ass_params = pcf_param[1]
                ass_params.each do |ass_param|
                  @product.public_send("pcf_assurance_#{ass_param[0]}=", ass_param[1])
                end

              # deal with top-level pcf fields
              else
                @product.public_send("pcf_#{pcf_param[0]}=", pcf_param[1])
              end
            end
          else

            # else, call the method on the model with the matching name. unless
            # it's "product," I'm not sure why that's even in there, and skip
            # created_at and updated_at, those are reserved fields for the
            # actual Rails model, and correspond to that, not the PACT file--
            # for the created/updated fields for that, refer to the 'created'
            # and 'updated' fields.
            unless param[0] == 'vendor_id' || param[0] == 'product' ||
              param[0] == 'created_at' || param[0] == 'updated_at' ||
              param[0] == 'preceding_pf_ids'
              @product.public_send("#{param[0]}=", param[1])
            end

          end
        end
      } # end format.json block
    end

    respond_to do |format|

      if @product.save

        # 'created_at' is an auto Rails field. PACT specifies 'created', so fill
        if @product.created.blank?
          @product.created = @product.created_at
          @product.save
        end

        format.html {
          redirect_to product_url(@product), notice: "Product successfully created."
        }

        format.json {
          # parent_id is initially set to the parent_id from the sending system,
          # and is just used to re-connect the child to the parent on the
          # receiving end. So use it to get the parent, then store the relationship
          # in preceding_pf_ids, and clear parent_id. It's transient and just for
          # transfer

          # dangerous hack, but if you sort these by date it would probably work
          if parent_product = Product.where( ["original_id = ?", @product.parent_id] ).order("created_at DESC").first
            logger.debug "================> fixing parent_product: #{parent_product.id}"
            # unless parent_product.preceding_pf_ids == @product.id
              parent_product.preceding_pf_ids << @product.id
              parent_product.save
            # end
          end

          @product.parent_id = nil
          @product.save
          render :show, status: :created
        }
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
        format.html {
          redirect_to product_url(@product), notice: "Product successfully updated."
        }
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
      format.html { redirect_to products_url, notice: "Product successfully destroyed." }
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
        :original_id, # if received, ID on previous system
        :parent_id, # parent ID on *this* system
        :vendor_id, :spec_version, :version,
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
        :pcf_biogenic_accounting_methodology,
        :pcf_boundary_processes_description,
        :pcf_reference_period_start, :pcf_reference_period_end,
        :pcf_geography_country_subdivision,
        :pcf_geography_country, :pcf_geography_region_or_subregion,
        :pcf_secondary_emission_factor_sources,
        :pcf_exempted_emissions_percent, :pcf_exempted_emissions_description,
        :pcf_packaging_emissions_included, :pcf_packaging_ghg_emissions,
        :pcf_allocation_rules_description,
        :pcf_uncertainty_assessment_description,
        :pcf_primary_data_share, :pcf_allocation_rules_description,
        :pcf_uncertainty_assessment_description,
        :pcf_dqi_coverage_percent, :pcf_dqi_technological_dqr,
        :pcf_dqi_temporal_dqr,
        :pcf_dqi_geographical_dqr, :pcf_dqi_completeness_dqr,
        :pcf_dqi_reliability_dqr,
        :pcf_assurance_coverage, :pcf_assurance_level, :pcf_assurance_boundary,
        :pcf_assurance_provider_name,
        :pcf_assurance_completed_at, :pcf_assurance_standard_name,
        :pcf_assurance_comments, :extensions,
        pcf_cross_sectoral_standards_used: [],
        pcf_product_or_sector_specific_rules: [],
        scopes_included: [],
        preceding_pf_ids: []
      )
    end
end
