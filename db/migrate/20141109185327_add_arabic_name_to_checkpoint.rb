class AddArabicNameToCheckpoint < ActiveRecord::Migration
  def change
    add_column :checkpoints, :ar, :string
  end
end
