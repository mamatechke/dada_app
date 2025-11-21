class AddVisibilityToContents < ActiveRecord::Migration[8.0]
  def change
    add_column :contents, :visibility, :string, default: "public", null: false
    add_index :contents, :visibility
  end
end
