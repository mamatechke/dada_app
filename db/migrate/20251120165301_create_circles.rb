class CreateCircles < ActiveRecord::Migration[8.0]
  def change
    create_table :circles do |t|
      t.string :name, null: false
      t.text :description
      t.string :stage_focus
      t.string :region
      t.integer :member_count, default: 0
      t.integer :post_count, default: 0
      t.boolean :is_private, default: false
      t.timestamps
    end

    add_index :circles, :stage_focus
    add_index :circles, :region
    add_index :circles, :is_private
  end
end
