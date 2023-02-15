class CreateSources < ActiveRecord::Migration[7.0]
  def change
    create_table :sources, id: :uuid do |t|
      t.references :product, null: false, foreign_key: true, type: :uuid
      t.references :node, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
