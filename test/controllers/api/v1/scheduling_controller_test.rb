require "test_helper"

class Api::V1::SchedulingControllerTest < ActionDispatch::IntegrationTest
  def json_response
    ActiveSupport::JSON.decode @response.body
  end

  test "taking service reservations over the phone in a single step" do
    post "http://127.0.0.1:3000/api/v1/scheduling", params: {
      "first_name": "Alice",
      "last_name": "Liddell",
      "license_number": "S54318719",
      phone_number: '774-867-5309',
      email: 'alice.liddell@gmail.com',
      "registration_number": "9KDB90",
      "make": "Nissan",
      "model": "Sentra",
      "color": "White",
      "date": "2023-10-06",
      "time": "10:30:00",
      "description": "broken engine",
      "status": "Pending"
    }

    assert_equal json_response["date"], "2023-10-06"
    assert_equal Time.parse(json_response["time"]).strftime("%R"), "10:30"
    assert_equal json_response["description"], "broken engine"
    assert_equal json_response["status"], "Pending"
  end

  test "looking up reservations for a customer by license number" do
    post "http://127.0.0.1:3000/api/v1/scheduling", params: {
      "first_name": "Alice",
      "last_name": "Liddell",
      "license_number": "S54318719",
      phone_number: '774-867-5309',
      email: 'alice.liddell@gmail.com',
      "registration_number": "9KDB90",
      "make": "Nissan",
      "model": "Sentra",
      "color": "White",
      "date": "2023-10-06",
      "time": "10:30:00",
      "description": "broken engine",
      "status": "Pending"
    }

    get "http://127.0.0.1:3000/api/v1/scheduling", params: { "license_number": "S54318719" }
    assert_equal json_response.size, 1
    assert_equal json_response[0]["description"], "broken engine"
    assert_equal json_response[0]["status"], "Pending"
  end
end
