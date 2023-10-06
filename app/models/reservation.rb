class Reservation < ApplicationRecord
  validates :date, presence: true
  validates :time, presence: true
  validates :description, presence: true
  validates :status, presence: true
  belongs_to :vehicle
end
