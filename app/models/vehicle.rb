class Vehicle < ApplicationRecord
  belongs_to :customer
  has_many :reservations
end
