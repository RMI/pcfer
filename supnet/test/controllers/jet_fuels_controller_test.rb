require "test_helper"

class JetFuelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @jet_fuel = jet_fuels(:one)
  end

  test "should get index" do
    get jet_fuels_url
    assert_response :success
  end

  test "should get new" do
    get new_jet_fuel_url
    assert_response :success
  end

  test "should create jet_fuel" do
    assert_difference("JetFuel.count") do
      post jet_fuels_url, params: { jet_fuel: { carbon_intensity: @jet_fuel.carbon_intensity, category: @jet_fuel.category, location: @jet_fuel.location, produced_at: @jet_fuel.produced_at, subcategory: @jet_fuel.subcategory, unit: @jet_fuel.unit, vendor: @jet_fuel.vendor, volume: @jet_fuel.volume } }
    end

    assert_redirected_to jet_fuel_url(JetFuel.last)
  end

  test "should show jet_fuel" do
    get jet_fuel_url(@jet_fuel)
    assert_response :success
  end

  test "should get edit" do
    get edit_jet_fuel_url(@jet_fuel)
    assert_response :success
  end

  test "should update jet_fuel" do
    patch jet_fuel_url(@jet_fuel), params: { jet_fuel: { carbon_intensity: @jet_fuel.carbon_intensity, category: @jet_fuel.category, location: @jet_fuel.location, produced_at: @jet_fuel.produced_at, subcategory: @jet_fuel.subcategory, unit: @jet_fuel.unit, vendor: @jet_fuel.vendor, volume: @jet_fuel.volume } }
    assert_redirected_to jet_fuel_url(@jet_fuel)
  end

  test "should destroy jet_fuel" do
    assert_difference("JetFuel.count", -1) do
      delete jet_fuel_url(@jet_fuel)
    end

    assert_redirected_to jet_fuels_url
  end
end
