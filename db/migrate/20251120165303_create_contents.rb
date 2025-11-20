class CreateContents < ActiveRecord::Migration[8.0]
  def change
    create_table :contents do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.string :content_type
      t.text :stage_tags
      t.text :symptom_tags
      t.string :locale, default: "en"
      t.string :author
      t.string :source_url
      t.integer :view_count, default: 0
      t.boolean :published, default: false
      t.timestamps
    end

    add_index :contents, :content_type
    add_index :contents, :locale
    add_index :contents, :published
    add_index :contents, :created_at
  end
end
