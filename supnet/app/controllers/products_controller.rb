class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products or /products.json
  def index
    @title = "PCFs"
    @products = Product.all
  end

  # GET /products/1 or /products/1.json
  def show
    @title = "PCF"
    respond_to do |format|
      format.html { render :show }
      format.json do
        @top={}
        @pcf={}
        @dqi={}
        @assurance={}

        # go through fields
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

        render "products/pact"
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
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
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
        :spec_version, :preceding_pf_ids, :version, :created, :updated, :status, :status_comment, :validity_period_start, :validity_period_end, :company_name, :company_ids, :product_description, :product_ids, :product_category_cpc, :product_name_company, :comment, :pcf_declared_unit, :pcf_unitary_product_amount, :pcf_pcf_excluding_biogenic, :pcf_pcf_including_biogenic, :pcf_fossil_ghg_emissions, :pcf_fossil_carbon_content, :pcf_biogenic_carbon_content, :pcf_d_luc_ghg_emissions, :pcf_land_management_ghg_emissions, :pcf_other_biogenic_ghg_emissions, :pcf_i_luc_ghg_emissions, :pcf_biogenic_carbon_withdrawal, :pcf_aircraft_ghg_emissions, :pcf_characterization_factors, :pcf_cross_sectoral_standards_used, :pcf_product_or_sector_specific_rules, :pcf_biogenic_accounting_methodology, :pcf_boundary_processes_description, :pcf_reference_period_start, :pcf_reference_period_end, :pcf_geography_country_subdivision, :pcf_geography_country, :pcf_geography_region_or_subregion, :pcf_secondary_emission_factor_sources, :pcf_exempted_emissions_percent, :pcf_exempted_emissions_description, :pcf_packaging_emissions_included, :pcf_packaging_ghg_emissions, :pcf_allocation_rules_description, :pcf_uncertainty_assessment_description, :pcf_primary_data_share, :pcf_allocation_rules_description, :pcf_uncertainty_assessment_description, :pcf_dqi_coverage_percent, :pcf_dqi_technological_dqr, :pcf_dqi_temporal_dqr, :pcf_dqi_geographical_dqr, :pcf_dqi_completeness_dqr, :pcf_dqi_reliability_dqr, :pcf_assurance_coverage, :pcf_assurance_level, :pcf_assurance_boundary, :pcf_assurance_provider_name, :pcf_assurance_completed_at, :pcf_assurance_standard_name, :pcf_assurance_comments, :extensions
      )
    end
end
