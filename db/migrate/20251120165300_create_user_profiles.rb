class CreateUserProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :user_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :stage
      t.text :symptoms
      t.string :country
      t.string :locale, default: "en"
      t.string :anonymous_handle
      t.timestamps
    end

    add_index :user_profiles, :user_id, unique: true
    add_index :user_profiles, :anonymous_handle, unique: true
  end
end
