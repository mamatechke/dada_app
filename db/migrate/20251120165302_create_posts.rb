class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.references :circle, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :content, null: false
      t.string :anonymous_handle, null: false
      t.integer :likes_count, default: 0
      t.integer :replies_count, default: 0
      t.timestamps
    end

    add_index :posts, :created_at
    add_index :posts, :likes_count
  end
end
