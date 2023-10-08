class Reservation < ApplicationRecord
  validates :date, presence: true
  validates :time, presence: true
  validates :duration_hours, presence: true
  validates :description, presence: true
  validates :status, presence: true
  belongs_to :vehicle

  def start_date_time
    DateTime.new(date.year, date.month, date.day, time.to_time.hour, time.to_time.min, time.to_time.sec)
  end

  def end_date_time
    DateTime.new(date.year, date.month, date.day, time.to_time.hour + duration_hours, time.to_time.min, time.to_time.sec)
  end

  # Returns true if the scheduled time ranges overlap.

  def conflicts_with(reservation)
    end_date_time > reservation.start_date_time && reservation.end_date_time > start_date_time
  end
end
