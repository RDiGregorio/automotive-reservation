class Customer < ApplicationRecord
  validates :license_number, uniqueness: true
  has_many :vehicles
end
