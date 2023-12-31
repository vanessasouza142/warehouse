class Warehouse < ApplicationRecord
  validates :name, :code, :city, :description, :address, :cep, :area, presence: true
  validates :code, uniqueness: true

  def full_description
    "#{code} - #{name}"
  end
end
