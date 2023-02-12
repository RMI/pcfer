class JetFuelsController < ApplicationController
  before_action :set_jet_fuel, only: %i[ show edit update destroy ]

  # GET /jet_fuels or /jet_fuels.json
  def index
    @jet_fuels = JetFuel.all
  end

  # GET /jet_fuels/1 or /jet_fuels/1.json
  def show
  end

  # GET /jet_fuels/new
  def new
    @jet_fuel = JetFuel.new
  end

  # GET /jet_fuels/1/edit
  def edit
  end

  # POST /jet_fuels or /jet_fuels.json
  def create
    @jet_fuel = JetFuel.new(jet_fuel_params)

    if @jet_fuel.get_nodes.present?

      # iterate through nodes and look for whatever you're looking for--probably carbon intensity
      # But for now, just grab value from first node
      @jet_fuel.carbon_intensity = @jet_fuel.get_nodes.first.get_carbon_intensity

    # Do some geo stuff to see if the location is in the US. But for now...
    elsif @jet_fuel.location.present? && @jet_fuel.location = "US"
      @jet_fuel.carbon_intensity = "241.10 kgCO2 per MWh"
    else
      # use global value
      @jet_fuel.carbon_intensity = JetFuel::GLOBAL_CARBON_INTENSITY
    end

    respond_to do |format|
      if @jet_fuel.save
        format.html { redirect_to jet_fuel_url(@jet_fuel), notice: "Jet fuel was successfully created." }
        format.json { render :show, status: :created, location: @jet_fuel }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @jet_fuel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jet_fuels/1 or /jet_fuels/1.json
  def update
    respond_to do |format|
      if @jet_fuel.update(jet_fuel_params)
        format.html { redirect_to jet_fuel_url(@jet_fuel), notice: "Jet fuel was successfully updated." }
        format.json { render :show, status: :ok, location: @jet_fuel }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @jet_fuel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jet_fuels/1 or /jet_fuels/1.json
  def destroy
    @jet_fuel.destroy

    respond_to do |format|
      format.html { redirect_to jet_fuels_url, notice: "Jet fuel was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jet_fuel
      @jet_fuel = JetFuel.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def jet_fuel_params
      params.require(:jet_fuel).permit(:volume, :unit, :category, :subcategory, :location, :vendor, :carbon_intensity, :produced_at)
    end
end
