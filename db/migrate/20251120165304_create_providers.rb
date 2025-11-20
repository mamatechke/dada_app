class CreateProviders < ActiveRecord::Migration[8.0]
  def change
    create_table :providers do |t|
      t.string :name, null: false
      t.string :category
      t.text :description
      t.string :country
      t.string :region
      t.string :phone
      t.string :email
      t.string :website
      t.text :services
      t.boolean :verified, default: false
      t.integer :contact_count, default: 0
      t.timestamps
    end

    add_index :providers, :category
    add_index :providers, :country
    add_index :providers, :verified
    add_index :providers, :created_at
  end
end
