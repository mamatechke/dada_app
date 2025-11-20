class CreateNudges < ActiveRecord::Migration[8.0]
  def change
    create_table :nudges do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.string :nudge_type
      t.text :stage_targets
      t.text :symptom_targets
      t.string :cta_text
      t.string :cta_url
      t.boolean :active, default: true
      t.integer :priority, default: 0
      t.timestamps
    end

    add_index :nudges, :nudge_type
    add_index :nudges, :active
    add_index :nudges, :priority
  end
end
