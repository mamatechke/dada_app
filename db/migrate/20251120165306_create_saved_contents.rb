class CreateSavedContents < ActiveRecord::Migration[8.0]
  def change
    create_table :saved_contents do |t|
      t.references :user, null: false, foreign_key: true
      t.references :content, null: false, foreign_key: true
      t.timestamps
    end

    add_index :saved_contents, [:user_id, :content_id], unique: true
  end
end
