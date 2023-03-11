class CreateVendors < ActiveRecord::Migration[7.0]
  def change
    create_table :vendors, id: :uuid do |t|
      t.string :name
      t.string :email
      t.text :email_message
      t.text :description
      t.string :api_endpoint
      t.string :api_key

      t.timestamps
    end
  end
end
