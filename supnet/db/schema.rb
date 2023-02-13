# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_02_11_223225) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "nodes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "owner"
    t.string "category"
    t.string "subcategory"
    t.string "url"
    t.string "api_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "spec_version"
    t.string "preceding_pf_ids"
    t.integer "version"
    t.string "created"
    t.string "updated"
    t.string "status"
    t.string "status_comment"
    t.string "validity_period_start"
    t.string "validity_period_end"
    t.string "company_name"
    t.string "company_ids"
    t.string "product_description"
    t.string "product_ids"
    t.string "product_category_cpc"
    t.string "product_name_company"
    t.string "comment"
    t.string "pcf_declared_unit"
    t.string "pcf_unitary_product_amount"
    t.string "pcf_pcf_excluding_biogenic"
    t.string "pcf_pcf_including_biogenic"
    t.string "pcf_fossil_ghg_emissions"
    t.string "pcf_fossil_carbon_content"
    t.string "pcf_biogenic_carbon_content"
    t.string "pcf_d_luc_ghg_emissions"
    t.string "pcf_land_management_ghg_emissions"
    t.string "pcf_other_biogenic_ghg_emissions"
    t.string "pcf_i_luc_ghg_emissions"
    t.string "pcf_biogenic_carbon_withdrawal"
    t.string "pcf_aircraft_ghg_emissions"
    t.string "pcf_characterization_factors"
    t.string "pcf_cross_sectoral_standards_used"
    t.string "pcf_product_or_sector_specific_rules"
    t.string "pcf_biogenic_accounting_methodology"
    t.string "pcf_boundary_processes_description"
    t.string "pcf_reference_period_start"
    t.string "pcf_reference_period_end"
    t.string "pcf_geography_country_subdivision"
    t.string "pcf_geography_country"
    t.string "pcf_geography_region_or_subregion"
    t.string "pcf_secondary_emission_factor_sources"
    t.decimal "pcf_exempted_emissions_percent"
    t.string "pcf_exempted_emissions_description"
    t.boolean "pcf_packaging_emissions_included"
    t.string "pcf_packaging_ghg_emissions"
    t.string "pcf_allocation_rules_description"
    t.string "pcf_uncertainty_assessment_description"
    t.decimal "pcf_primary_data_share"
    t.decimal "pcf_dqi_coverage_percent"
    t.decimal "pcf_dqi_technological_dqr"
    t.decimal "pcf_dqi_temporal_dqr"
    t.decimal "pcf_dqi_geographical_dqr"
    t.decimal "pcf_dqi_completeness_dqr"
    t.decimal "pcf_dqi_reliability_dqr"
    t.string "pcf_assurance_coverage"
    t.string "pcf_assurance_level"
    t.string "pcf_assurance_boundary"
    t.string "pcf_assurance_provider_name"
    t.string "pcf_assurance_completed_at"
    t.string "pcf_assurance_standard_name"
    t.string "pcf_assurance_comments"
    t.string "extensions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
