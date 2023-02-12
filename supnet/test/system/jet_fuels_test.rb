require "application_system_test_case"

class JetFuelsTest < ApplicationSystemTestCase
  setup do
    @jet_fuel = jet_fuels(:one)
  end

  test "visiting the index" do
    visit jet_fuels_url
    assert_selector "h1", text: "Jet fuels"
  end

  test "should create jet fuel" do
    visit jet_fuels_url
    click_on "New jet fuel"

    fill_in "Carbon intensity", with: @jet_fuel.carbon_intensity
    fill_in "Category", with: @jet_fuel.category
    fill_in "Location", with: @jet_fuel.location
    fill_in "Produced at", with: @jet_fuel.produced_at
    fill_in "Subcategory", with: @jet_fuel.subcategory
    fill_in "Unit", with: @jet_fuel.unit
    fill_in "Vendor", with: @jet_fuel.vendor
    fill_in "Volume", with: @jet_fuel.volume
    click_on "Create Jet fuel"

    assert_text "Jet fuel was successfully created"
    click_on "Back"
  end

  test "should update Jet fuel" do
    visit jet_fuel_url(@jet_fuel)
    click_on "Edit this jet fuel", match: :first

    fill_in "Carbon intensity", with: @jet_fuel.carbon_intensity
    fill_in "Category", with: @jet_fuel.category
    fill_in "Location", with: @jet_fuel.location
    fill_in "Produced at", with: @jet_fuel.produced_at
    fill_in "Subcategory", with: @jet_fuel.subcategory
    fill_in "Unit", with: @jet_fuel.unit
    fill_in "Vendor", with: @jet_fuel.vendor
    fill_in "Volume", with: @jet_fuel.volume
    click_on "Update Jet fuel"

    assert_text "Jet fuel was successfully updated"
    click_on "Back"
  end

  test "should destroy Jet fuel" do
    visit jet_fuel_url(@jet_fuel)
    click_on "Destroy this jet fuel", match: :first

    assert_text "Jet fuel was successfully destroyed"
  end
end
