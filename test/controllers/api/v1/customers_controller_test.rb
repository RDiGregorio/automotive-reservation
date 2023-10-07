require "test_helper"

class Api::V1::CustomersControllerTest < ActionDispatch::IntegrationTest
  def json_response
    ActiveSupport::JSON.decode @response.body
  end

  test "customer can be created" do
    post "http://127.0.0.1:3000/api/v1/customers/", params: {first_name: "a", last_name: "b", license_number: "c"}
    assert_equal json_response["first_name"], "a"
    assert_equal json_response["last_name"], "b"
    assert_equal json_response["license_number"], "c"
    assert_nil json_response["phone_number"]
    assert_nil json_response["email"]
  end

  test "license numbers are unique" do
    post "http://127.0.0.1:3000/api/v1/customers/", params: {first_name: "a", last_name: "b", license_number: "c"}
    assert_equal json_response["first_name"], "a"
    post "http://127.0.0.1:3000/api/v1/customers/", params: {first_name: "a", last_name: "b", license_number: "c"}
    assert_equal json_response["error"], "Failed to create customer."
  end

  test "customer can be updated" do
    post "http://127.0.0.1:3000/api/v1/customers/", params: {first_name: "a", last_name: "b", license_number: "c"}
    assert_equal json_response["first_name"], "a"
    id = json_response["id"]
    put "http://127.0.0.1:3000/api/v1/customers/#{id}", params: {first_name: "x"}
    assert_equal json_response["message"], "Customer updated."
    get "http://127.0.0.1:3000/api/v1/customers/#{id}"
    assert_equal json_response["id"], id
  end

  test "customer can be deleted" do
    post "http://127.0.0.1:3000/api/v1/customers/", params: {first_name: "a", last_name: "b", license_number: "c"}
    assert_equal json_response["first_name"], "a"
    id = json_response["id"]
    delete "http://127.0.0.1:3000/api/v1/customers/#{id}"
    assert_equal json_response["message"], "Customer deleted."
    get "http://127.0.0.1:3000/api/v1/customers/#{id}"
    assert_equal json_response["error"], "Failed to find customer."
  end
end
