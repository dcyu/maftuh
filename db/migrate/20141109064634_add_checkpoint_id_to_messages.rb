class AddCheckpointIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :checkpoint_id, :integer
  end
end
