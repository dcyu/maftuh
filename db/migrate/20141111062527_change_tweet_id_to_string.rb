class ChangeTweetIdToString < ActiveRecord::Migration
  def change
    change_column :messages, :tweet_id, :string
  end
end
