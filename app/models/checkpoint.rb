class Checkpoint < ActiveRecord::Base
  validates :open, inclusion: { :in => [true, false] }
  validates :name, presence: true, uniqueness: true

  has_many :messages

  def name_locale
    if I18n.locale == :ar
      ar
    else
      name
    end
  end
end


