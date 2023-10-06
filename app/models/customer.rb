class Customer < ApplicationRecord
  validates :license_number, uniqueness: true, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  has_many :vehicles
end
