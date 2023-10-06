require "test_helper"

class Api::V1::CustomersControllerTest < ActionDispatch::IntegrationTest
  test "customer can be created" do
    assert !Customer.find_by(first_name: 'Alice', last_name: 'Liddell')
    Customer.create(first_name: 'Alice', last_name: 'Liddell', license_number: '9KDB90', phone_number: '774-867-5309', email: 'alice.liddell@gmail.com')
    assert Customer.find_by(first_name: 'Alice', last_name: 'Liddell').license_number == '9KDB90'
  end
end
