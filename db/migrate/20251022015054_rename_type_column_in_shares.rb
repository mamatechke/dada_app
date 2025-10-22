class RenameTypeColumnInShares < ActiveRecord::Migration[8.0]
  def change
    rename_column :shares, :type, :share_type
  end
end
