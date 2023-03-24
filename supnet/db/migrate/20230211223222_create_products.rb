class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products, id: :uuid do |t|
      t.string :original_id
      t.uuid :vendor_id
      t.string :spec_version
      t.string :preceding_pf_ids, array: true, default: []
      t.string :scopes_included, array: true, default: []
      t.integer :version
      t.datetime :created
      t.datetime :updated
      t.string :status
      t.string :status_comment
      t.datetime :validity_period_start
      t.datetime :validity_period_end
      t.string :company_name
      t.string :company_ids
      t.string :product_description
      t.string :product_ids
      t.string :product_category_cpc
      t.string :product_name_company
      t.string :comment
      t.string :pcf_declared_unit
      t.decimal :pcf_unitary_product_amount
      t.decimal :pcf_pcf_excluding_biogenic
      t.decimal :pcf_pcf_including_biogenic
      t.decimal :pcf_fossil_ghg_emissions
      t.decimal :pcf_fossil_carbon_content
      t.decimal :pcf_biogenic_carbon_content
      t.decimal :pcf_d_luc_ghg_emissions
      t.decimal :pcf_land_management_ghg_emissions
      t.decimal :pcf_other_biogenic_ghg_emissions
      t.decimal :pcf_i_luc_ghg_emissions
      t.decimal :pcf_biogenic_carbon_withdrawal
      t.decimal :pcf_aircraft_ghg_emissions
      t.string :pcf_characterization_factors
      t.string :pcf_cross_sectoral_standards_used, array: true, default: []
      t.string :pcf_product_or_sector_specific_rules, array: true, default: []
      t.string :pcf_biogenic_accounting_methodology
      t.string :pcf_boundary_processes_description
      t.datetime :pcf_reference_period_start
      t.datetime :pcf_reference_period_end
      t.string :pcf_geography_country_subdivision
      t.string :pcf_geography_country
      t.string :pcf_geography_region_or_subregion
      t.string :pcf_secondary_emission_factor_sources
      t.decimal :pcf_exempted_emissions_percent
      t.string :pcf_exempted_emissions_description
      t.boolean :pcf_packaging_emissions_included
      t.string :pcf_packaging_ghg_emissions
      t.string :pcf_allocation_rules_description
      t.string :pcf_uncertainty_assessment_description
      t.decimal :pcf_primary_data_share
      t.decimal :pcf_dqi_coverage_percent
      t.decimal :pcf_dqi_technological_dqr
      t.decimal :pcf_dqi_temporal_dqr
      t.decimal :pcf_dqi_geographical_dqr
      t.decimal :pcf_dqi_completeness_dqr
      t.decimal :pcf_dqi_reliability_dqr
      t.string :pcf_assurance_coverage
      t.string :pcf_assurance_level
      t.string :pcf_assurance_boundary
      t.string :pcf_assurance_provider_name
      t.datetime :pcf_assurance_completed_at
      t.string :pcf_assurance_standard_name
      t.string :pcf_assurance_comments
      t.string :extensions

      t.timestamps
    end
  end
end
