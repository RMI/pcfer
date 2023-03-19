class VendorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_vendor, only: %i[ show edit update destroy ]

  # GET /vendors or /vendors.json
  def index
    @title = "Vendors"
    @vendors = Vendor.all
  end

  # GET /vendors/1 or /vendors/1.json
  def show
    @title = "Vendor"
  end

  # GET /vendors/new
  def new
    @title = "New Vendor"
    @vendor = Vendor.new
  end

  # GET /vendors/1/edit
  def edit
    @title = "Edit Vendor"
  end

  # POST /vendors or /vendors.json
  def create
    @vendor = Vendor.new(vendor_params)
    @vendor.api_key = "sk_" + SecureRandom.urlsafe_base64

    respond_to do |format|
      if @vendor.save
        format.html { redirect_to vendor_url(@vendor), notice: "Vendor was successfully created." }
        format.json { render :show, status: :created, location: @vendor }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vendors/1 or /vendors/1.json
  def update
    respond_to do |format|
      if @vendor.update(vendor_params)
        format.html { redirect_to vendor_url(@vendor), notice: "Vendor was successfully updated." }
        format.json { render :show, status: :ok, location: @vendor }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vendors/1 or /vendors/1.json
  def destroy
    @vendor.destroy

    respond_to do |format|
      format.html { redirect_to vendors_url, notice: "Vendor was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vendor
      @vendor = Vendor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vendor_params
      # , :api_endpoint, :api_key
      params.require(:vendor).permit(:name, :email, :email_message, :description)
    end
end
