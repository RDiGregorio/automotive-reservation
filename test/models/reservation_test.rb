require "test_helper"

class ReservationTest < ActiveSupport::TestCase
  test "reservations can be created" do
    customer = Customer.create(first_name: 'Alice', last_name: 'Liddell', license_number: 'S54318719', phone_number: '774-867-5309', email: 'alice.liddell@gmail.com')
    vehicle = Vehicle.create(customer_id: customer.id, make: "Nissan", model: "Sentra", color: "White", registration_number: "9KDB90")
    Reservation.create(vehicle_id: vehicle.id, date: '2023-10-06', time: '12:00:00', description: "broken engine", status: "Ready", duration_hours: 1)
    reservation = Reservation.find_by(vehicle_id: vehicle.id, date: '2023-10-06')
    assert reservation.description == 'broken engine'
  end

  test "reservations can be updated" do
    customer = Customer.create(first_name: 'Alice', last_name: 'Liddell', license_number: 'S54318719', phone_number: '774-867-5309', email: 'alice.liddell@gmail.com')
    vehicle = Vehicle.create(customer_id: customer.id, make: "Nissan", model: "Sentra", color: "White", registration_number: "9KDB90")
    Reservation.create(vehicle_id: vehicle.id, date: '2023-10-06', time: '12:00:00', description: "broken engine", status: "Ready", duration_hours: 1)
    Reservation.update(Reservation.find_by(vehicle_id: vehicle.id, date: '2023-10-06').id, :status => "Done")
    assert Reservation.find_by(vehicle_id: vehicle.id, date: '2023-10-06').status == "Done"
  end

  test "reservations can be deleted" do
    customer = Customer.create(first_name: 'Alice', last_name: 'Liddell', license_number: 'S54318719', phone_number: '774-867-5309', email: 'alice.liddell@gmail.com')
    vehicle = Vehicle.create(customer_id: customer.id, make: "Nissan", model: "Sentra", color: "White", registration_number: "9KDB90")
    reservation = Reservation.create(vehicle_id: vehicle.id, date: '2023-10-06', time: '12:00:00', description: "broken engine", status: "Ready", duration_hours: 1)
    Reservation.destroy(reservation.id)
    assert !Reservation.find_by(vehicle_id: vehicle.id, date: '2023-10-06')
  end
end
