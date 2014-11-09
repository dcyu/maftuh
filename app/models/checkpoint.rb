class Checkpoint < ActiveRecord::Base
  validates :open, inclusion: { :in => [true, false] }
  validates :name, presence: true, uniqueness: true

  has_many :messages
end
