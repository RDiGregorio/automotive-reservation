require "test_helper"

class Api::V1::ReservationsControllerTest < ActionDispatch::IntegrationTest
  def json_response
    ActiveSupport::JSON.decode @response.body
  end

  test "reservations can be created" do
    post "http://127.0.0.1:3000/api/v1/customers/", params: { first_name: "a", last_name: "b", license_number: "c" }
    id = json_response["id"]
    post "http://127.0.0.1:3000/api/v1/customers/#{id}/vehicles/", params: { make: "Nissan", model: "Sentra", color: "White", registration_number: "9KDB90" }
    vehicle_id = json_response["id"]
    post "http://127.0.0.1:3000/api/v1/customers/#{id}/vehicles/#{vehicle_id}/reservations", params: { date: "2023-10-06", time: "10:30:00", description: "broken engine", status: "Ready" }
    assert_equal DateTime.parse(json_response["date"]), DateTime.parse("2023-10-06")
    assert_equal Time.parse(json_response["time"]).strftime("%R"), "10:30"
    assert_equal json_response["description"], "broken engine"
    assert_equal json_response["status"], "Ready"
  end

  test "reservations can be updated" do
    post "http://127.0.0.1:3000/api/v1/customers/", params: { first_name: "a", last_name: "b", license_number: "c" }
    id = json_response["id"]
    post "http://127.0.0.1:3000/api/v1/customers/#{id}/vehicles/", params: { make: "Nissan", model: "Sentra", color: "White", registration_number: "9KDB90" }
    vehicle_id = json_response["id"]
    post "http://127.0.0.1:3000/api/v1/customers/#{id}/vehicles/#{vehicle_id}/reservations", params: { date: "2023-10-06", time: "10:30:00", description: "broken engine", status: "Ready" }
    reservation_id = json_response["id"]
    put "http://127.0.0.1:3000/api/v1/customers/#{id}/vehicles/#{vehicle_id}/reservations/#{reservation_id}", params: { date: "2023-10-06", time: "10:30:00", description: "broken engine", status: "Done" }
    assert_equal json_response["message"], "Reservation updated."
    get "http://127.0.0.1:3000/api/v1/customers/#{id}/vehicles/#{vehicle_id}/reservations/#{reservation_id}"
    assert_equal json_response["status"], "Done"
  end

  test "reservations can be deleted" do
    post "http://127.0.0.1:3000/api/v1/customers/", params: { first_name: "a", last_name: "b", license_number: "c" }
    id = json_response["id"]
    post "http://127.0.0.1:3000/api/v1/customers/#{id}/vehicles/", params: { make: "Nissan", model: "Sentra", color: "White", registration_number: "9KDB90" }
    vehicle_id = json_response["id"]
    post "http://127.0.0.1:3000/api/v1/customers/#{id}/vehicles/#{vehicle_id}/reservations", params: { date: "2023-10-06", time: "10:30:00", description: "broken engine", status: "Ready" }
    reservation_id = json_response["id"]
    delete "http://127.0.0.1:3000/api/v1/customers/#{id}/vehicles/#{vehicle_id}/reservations/#{reservation_id}"
    assert_equal json_response["message"], "Reservation deleted."
    get "http://127.0.0.1:3000/api/v1/customers/#{id}/vehicles/#{vehicle_id}/reservations/#{reservation_id}"
    assert_equal json_response["error"], "Failed to find reservation."
  end
end
