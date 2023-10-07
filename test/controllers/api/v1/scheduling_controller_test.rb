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
      "phone_number": '774-867-5309',
      "email": 'alice.liddell@gmail.com',
      "registration_number": "9KDB90",
      "make": "Nissan",
      "model": "Sentra",
      "color": "White",
      "date": "2023-10-06",
      "time": "10:30:00",
      "description": "broken engine",
      "status": "Pending",
      "duration_hours": 1
    }

    assert_equal json_response["date"], "2023-10-06"
    assert_equal Time.parse(json_response["time"]).strftime("%R"), "10:30"
    assert_equal json_response["description"], "broken engine"
    assert_equal json_response["status"], "Pending"
    assert_equal json_response["duration_hours"], 1
  end

  test "making multiple reservations does not duplicate customers or vehicles" do
    # We are making 2 appointments, to fix 2 different things, on the same car, at different dates.

    post "http://127.0.0.1:3000/api/v1/scheduling", params: {
      "first_name": "Alice",
      "last_name": "Liddell",
      "license_number": "S54318719",
      "phone_number": '774-867-5309',
      "email": 'alice.liddell@gmail.com',
      "registration_number": "9KDB90",
      "make": "Nissan",
      "model": "Sentra",
      "color": "White",
      "date": "2023-10-06",
      "time": "10:30:00",
      "description": "broken engine",
      "status": "Pending",
      "duration_hours": 1
    }

    post "http://127.0.0.1:3000/api/v1/scheduling", params: {
      "first_name": "Alice",
      "last_name": "Liddell",
      "license_number": "S54318719",
      "phone_number": '774-867-5309',
      "email": 'alice.liddell@gmail.com',
      "registration_number": "9KDB90",
      "make": "Nissan",
      "model": "Sentra",
      "color": "White",
      "date": "2023-10-07",
      "time": "10:30:00",
      "description": "broken window",
      "status": "Pending",
      "duration_hours": 1
    }

    # Verify 2 reservations are made.

    get "http://127.0.0.1:3000/api/v1/scheduling", params: { "license_number": "S54318719" }
    assert_equal json_response.size, 2
    assert_equal json_response[0]["description"], "broken engine"
    assert_equal json_response[1]["description"], "broken window"

    # Verify only 1 customer is made.

    get "http://127.0.0.1:3000/api/v1/customers", params: { "license_number": "S54318719" }
    assert_equal json_response[0]["license_number"], "S54318719"
    assert_equal json_response.size, 1

    # Verify only 1 vehicle is made.

    id = json_response[0]["id"]
    get "http://127.0.0.1:3000/api/v1/customers/#{id}/vehicles", params: { "registration_number": "9KDB90" }
    assert_equal json_response[0]["registration_number"], "9KDB90"
    assert_equal json_response.size, 1
  end

  test "looking up reservations for a customer by license number" do
    post "http://127.0.0.1:3000/api/v1/scheduling", params: {
      "first_name": "Alice",
      "last_name": "Liddell",
      "license_number": "S54318719",
      "phone_number": '774-867-5309',
      "email": 'alice.liddell@gmail.com',
      "registration_number": "9KDB90",
      "make": "Nissan",
      "model": "Sentra",
      "color": "White",
      "date": "2023-10-06",
      "time": "10:30:00",
      "description": "broken engine",
      "status": "Pending",
      "duration_hours": 1
    }

    # An earlier completed job that should no longer be found.

    post "http://127.0.0.1:3000/api/v1/scheduling", params: {
      "first_name": "Alice",
      "last_name": "Liddell",
      "license_number": "S54318719",
      "phone_number": '774-867-5309',
      "email": 'alice.liddell@gmail.com',
      "registration_number": "9KDB90",
      "make": "Nissan",
      "model": "Sentra",
      "color": "White",
      "date": "2022-10-06",
      "time": "10:30:00",
      "description": "broken engine",
      "status": "Closed",
      "duration_hours": 1
    }

    get "http://127.0.0.1:3000/api/v1/scheduling", params: { "license_number": "S54318719" }
    assert_equal json_response.size, 1
    assert_equal json_response[0]["description"], "broken engine"
    assert_equal json_response[0]["status"], "Pending"
    assert_equal json_response[0]["date"], "2023-10-06"
  end

  test "looking up reservations for a customer by name" do
    post "http://127.0.0.1:3000/api/v1/scheduling", params: {
      "first_name": "Alice",
      "last_name": "Liddell",
      "license_number": "S54318719",
      "phone_number": '774-867-5309',
      "email": 'alice.liddell@gmail.com',
      "registration_number": "9KDB90",
      "make": "Nissan",
      "model": "Sentra",
      "color": "White",
      "date": "2023-10-06",
      "time": "10:30:00",
      "description": "broken engine",
      "status": "Pending",
      "duration_hours": 1
    }

    # A customer with the same name, but a completed job. The license number and registration number are different. They
    # have the same name, phone number, and email because they are mother and daughter and decided to share accounts.

    post "http://127.0.0.1:3000/api/v1/scheduling", params: {
      "first_name": "Alice",
      "last_name": "Liddell",
      "license_number": "S54318720",
      "phone_number": '774-867-5309',
      "email": 'alice.liddell@gmail.com',
      "registration_number": "9KDB91",
      "make": "Nissan",
      "model": "Sentra",
      "color": "White",
      "date": "2022-10-06",
      "time": "10:30:00",
      "description": "broken engine",
      "status": "Closed",
      "duration_hours": 1
    }

    get "http://127.0.0.1:3000/api/v1/scheduling", params: { "first_name": "Alice", "last_name": "Liddell" }
    assert_equal json_response.size, 1
    assert_equal json_response[0]["description"], "broken engine"
    assert_equal json_response[0]["status"], "Pending"
    assert_equal json_response[0]["date"], "2023-10-06"
  end

  test "looking up reservations for a customer by name fails if multiple people have the same name and open reservations" do
    post "http://127.0.0.1:3000/api/v1/scheduling", params: {
      "first_name": "Alice",
      "last_name": "Liddell",
      "license_number": "S54318719",
      "phone_number": '774-867-5309',
      "email": 'alice.liddell@gmail.com',
      "registration_number": "9KDB90",
      "make": "Nissan",
      "model": "Sentra",
      "color": "White",
      "date": "2023-10-06",
      "time": "10:30:00",
      "description": "broken engine",
      "status": "Pending",
      "duration_hours": 1
    }

    # A customer with the same name. The license number and registration number are different. They have the same name,
    # phone number, and email because they are mother and daughter and decided to share accounts.

    post "http://127.0.0.1:3000/api/v1/scheduling", params: {
      "first_name": "Alice",
      "last_name": "Liddell",
      "license_number": "S54318720",
      "phone_number": '774-867-5309',
      "email": 'alice.liddell@gmail.com',
      "registration_number": "9KDB91",
      "make": "Nissan",
      "model": "Sentra",
      "color": "White",
      "date": "2023-10-06",
      "time": "10:30:00",
      "description": "broken engine",
      "status": "Pending",
      "duration_hours": 1
    }

    # A reason for failure and a possible resolution is given.

    get "http://127.0.0.1:3000/api/v1/scheduling", params: { "first_name": "Alice", "last_name": "Liddell" }
    assert_equal json_response["error"], "Found multiple customers. Please search by license number."
  end
end
