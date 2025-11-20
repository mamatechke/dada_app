class CreatePageSections < ActiveRecord::Migration[8.0]
  def change
    create_table :page_sections do |t|
      t.string :section_name, null: false
      t.integer :section_order, default: 0
      if connection.adapter_name == "PostgreSQL"
        t.jsonb :content_data, default: {}
      else
        t.text :content_data
      end
      t.boolean :active, default: true
      t.integer :updated_by_id
      t.timestamps
    end

    add_index :page_sections, :section_name, unique: true
    add_index :page_sections, :section_order
    add_index :page_sections, :active
  end
end
