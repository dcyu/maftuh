class AddTweetIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :tweet_id, :integer
  end
end
