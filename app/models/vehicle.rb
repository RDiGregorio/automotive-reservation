class Vehicle < ApplicationRecord
  validates :registration_number, uniqueness: true
  belongs_to :customer
  has_many :reservations
end
