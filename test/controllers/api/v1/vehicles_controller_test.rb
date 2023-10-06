require "test_helper"

class Api::V1::VehiclesControllerTest < ActionDispatch::IntegrationTest
  test "vehicles can be created" do
    customer = Customer.create(first_name: 'Alice', last_name: 'Liddell', license_number: 'S54318719', phone_number: '774-867-5309', email: 'alice.liddell@gmail.com')
    Vehicle.create(customer_id: customer.id, make: "Nissan", model: "Sentra", color: "White", registration_number: "9KDB90")
    vehicle = Vehicle.find_by(registration_number: "9KDB90")
    assert vehicle.registration_number == "9KDB90"
    assert vehicle.customer.license_number == 'S54318719'
  end

  test "registration numbers are unique" do
    customer = Customer.create(first_name: 'Alice', last_name: 'Liddell', license_number: 'S54318719', phone_number: '774-867-5309', email: 'alice.liddell@gmail.com')
    Vehicle.create(customer_id: customer.id, make: "Nissan", model: "Sentra", color: "White", registration_number: "9KDB90")
    assert_raise(ActiveRecord::RecordInvalid) do
      Vehicle.create!(customer_id: customer.id, make: "Nissan", model: "Sentra", color: "White", registration_number: "9KDB90")
    end
  end

  test "vehicles can be updated" do
    customer = Customer.create(first_name: 'Alice', last_name: 'Liddell', license_number: 'S54318719', phone_number: '774-867-5309', email: 'alice.liddell@gmail.com')
    Vehicle.create(customer_id: customer.id, make: "Nissan", model: "Sentra", color: "White", registration_number: "9KDB90")
    Vehicle.update(Vehicle.find_by(registration_number: "9KDB90").id, :color => "Red")
    assert Vehicle.find_by(registration_number: "9KDB90").color == "Red"
  end

  test "vehicles can be deleted" do
    customer = Customer.create(first_name: 'Alice', last_name: 'Liddell', license_number: 'S54318719', phone_number: '774-867-5309', email: 'alice.liddell@gmail.com')
    Vehicle.create(customer_id: customer.id, make: "Nissan", model: "Sentra", color: "White", registration_number: "9KDB90")
    Vehicle.destroy(Vehicle.find_by(registration_number: "9KDB90").id)
    assert !Vehicle.find_by(registration_number: "9KDB90")
  end
end
