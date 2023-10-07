require "test_helper"

class Api::V1::VehiclesControllerTest < ActionDispatch::IntegrationTest
  def json_response
    ActiveSupport::JSON.decode @response.body
  end

  test "vehicles can be created" do
    post "http://127.0.0.1:3000/api/v1/customers/", params: {first_name: "a", last_name: "b", license_number: "c"}
    id = json_response["id"]
    post "http://127.0.0.1:3000/api/v1/customers/#{id}/vehicles/", params: {make: "Nissan", model: "Sentra", color: "White", registration_number: "9KDB90"}
    assert_equal json_response["make"], "Nissan"
    assert_equal json_response["model"], "Sentra"
    assert_equal json_response["color"], "White"
    assert_equal json_response["registration_number"], "9KDB90"
  end

  test "registration numbers are unique" do
    post "http://127.0.0.1:3000/api/v1/customers/", params: {first_name: "a", last_name: "b", license_number: "c"}
    id = json_response["id"]
    post "http://127.0.0.1:3000/api/v1/customers/#{id}/vehicles/", params: {make: "Nissan", model: "Sentra", color: "White", registration_number: "9KDB90"}
    post "http://127.0.0.1:3000/api/v1/customers/#{id}/vehicles/", params: {make: "X", model: "Y", color: "Z", registration_number: "9KDB90"}
    assert_equal json_response["error"], "Failed to create vehicle."
  end

  test "vehicles can be updated" do
    post "http://127.0.0.1:3000/api/v1/customers/", params: {first_name: "a", last_name: "b", license_number: "c"}
    id = json_response["id"]
    post "http://127.0.0.1:3000/api/v1/customers/#{id}/vehicles/", params: {make: "Nissan", model: "Sentra", color: "White", registration_number: "9KDB90"}
    vehicle_id = json_response["id"]
    put "http://127.0.0.1:3000/api/v1/customers/#{id}/vehicles/#{vehicle_id}", params: {make: "Nissan", model: "Sentra", color: "Red", registration_number: "9KDB90"}
    assert_equal json_response["message"], "Vehicle updated."
    get "http://127.0.0.1:3000/api/v1/customers/#{id}/vehicles/#{vehicle_id}"
    assert_equal json_response["color"], "Red"
  end

  test "vehicles can be deleted" do
    post "http://127.0.0.1:3000/api/v1/customers/", params: {first_name: "a", last_name: "b", license_number: "c"}
    id = json_response["id"]
    post "http://127.0.0.1:3000/api/v1/customers/#{id}/vehicles/", params: {make: "Nissan", model: "Sentra", color: "White", registration_number: "9KDB90"}
    vehicle_id = json_response["id"]
    delete "http://127.0.0.1:3000/api/v1/customers/#{id}/vehicles/#{vehicle_id}"
    assert_equal json_response["message"], "Vehicle deleted."
    get "http://127.0.0.1:3000/api/v1/customers/#{id}/vehicles/#{vehicle_id}"
    assert_equal json_response["error"], "Failed to find vehicle."
  end
end
