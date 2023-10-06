class Vehicle < ApplicationRecord
  validates :registration_number, uniqueness: true, presence: true
  validates :make, presence: true
  validates :model, presence: true
  validates :color, presence: true
  belongs_to :customer
  has_many :reservations
end
