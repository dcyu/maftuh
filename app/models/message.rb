class Message < ActiveRecord::Base
  validates :body, presence: true
  validates :checkpoint_id, presence: true

  belongs_to :checkpoint

  alias_attribute :text, :body
end
