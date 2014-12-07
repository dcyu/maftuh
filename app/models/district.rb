class District < ActiveRecord::Base
  validates :en_name, presence: true, uniqueness: true
  
  has_many :checkpoints
end
