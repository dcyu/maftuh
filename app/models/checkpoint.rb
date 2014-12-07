class Checkpoint < ActiveRecord::Base
  validates :open, inclusion: { :in => [true, false] }
  validates :en_name, presence: true, uniqueness: true

  belongs_to :district
  has_many :messages

  def name
    if I18n.locale == :ar
      ar_name
    else
      en_name
    end
  end

  def description
    if I18n.locale == :ar
      ar_description
    else
      en_description
    end
  end
end


