class CreateJetFuels < ActiveRecord::Migration[7.0]
  def change
    create_table :jet_fuels, id: :uuid do |t|
      t.integer :volume
      t.string :unit
      t.string :category
      t.string :subcategory
      t.string :location
      t.string :vendor
      t.decimal :carbon_intensity
      t.datetime :produced_at

      t.timestamps
    end
  end
end
