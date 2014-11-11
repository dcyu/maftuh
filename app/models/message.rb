class Message < ActiveRecord::Base
  validates :body, presence: true
  validates :checkpoint_id, presence: true
  validates :tweet_id, uniqueness: true, allow_nil: true

  belongs_to :checkpoint

  alias_attribute :text, :body

  def closed?
    text.gsub("مغلق", "closed").include?('closed')
  end

  def open?
    text.gsub("مفتوح", "open").include?('open')
  end
end
