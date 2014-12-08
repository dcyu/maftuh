class District < ActiveRecord::Base
  validates :en_name, presence: true, uniqueness: true
  
  has_many :checkpoints

  def name
    if I18n.locale == :ar
      ar_name
    else
      en_name
    end
  end
end
