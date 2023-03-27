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

ActiveRecord::Schema[7.0].define(version: 2023_03_18_182549) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "customers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.text "description"
    t.string "api_endpoint"
    t.string "api_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "original_id"
    t.uuid "vendor_id"
    t.string "spec_version"
    t.string "preceding_pf_ids", default: [], array: true
    t.text "preceding_pf_urls", default: [], array: true
    t.string "scopes_included", default: [], array: true
    t.integer "version"
    t.datetime "created"
    t.datetime "updated"
    t.string "status"
    t.string "status_comment"
    t.datetime "validity_period_start"
    t.datetime "validity_period_end"
    t.string "company_name"
    t.string "company_ids"
    t.string "product_description"
    t.string "product_ids"
    t.string "product_category_cpc"
    t.string "product_name_company"
    t.string "comment"
    t.string "pcf_declared_unit"
    t.decimal "pcf_unitary_product_amount"
    t.decimal "pcf_pcf_excluding_biogenic"
    t.decimal "pcf_pcf_including_biogenic"
    t.decimal "pcf_fossil_ghg_emissions"
    t.decimal "pcf_fossil_carbon_content"
    t.decimal "pcf_biogenic_carbon_content"
    t.decimal "pcf_d_luc_ghg_emissions"
    t.decimal "pcf_land_management_ghg_emissions"
    t.decimal "pcf_other_biogenic_ghg_emissions"
    t.decimal "pcf_i_luc_ghg_emissions"
    t.decimal "pcf_biogenic_carbon_withdrawal"
    t.decimal "pcf_aircraft_ghg_emissions"
    t.string "pcf_characterization_factors"
    t.string "pcf_cross_sectoral_standards_used", default: [], array: true
    t.string "pcf_product_or_sector_specific_rules", default: [], array: true
    t.string "pcf_biogenic_accounting_methodology"
    t.string "pcf_boundary_processes_description"
    t.datetime "pcf_reference_period_start"
    t.datetime "pcf_reference_period_end"
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
    t.datetime "pcf_assurance_completed_at"
    t.string "pcf_assurance_standard_name"
    t.string "pcf_assurance_comments"
    t.string "extensions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vendors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.text "email_message"
    t.text "description"
    t.string "api_endpoint"
    t.string "api_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
