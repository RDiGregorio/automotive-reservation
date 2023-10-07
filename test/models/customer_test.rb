require "test_helper"

class CustomerTest < ActiveSupport::TestCase
  test "customer can be created" do
    assert !Customer.find_by(first_name: 'Alice', last_name: 'Liddell')
    Customer.create(first_name: 'Alice', last_name: 'Liddell', license_number: 'S54318719', phone_number: '774-867-5309', email: 'alice.liddell@gmail.com')
    customer = Customer.find_by(first_name: 'Alice', last_name: 'Liddell')
    assert customer.license_number == 'S54318719'
    assert customer.phone_number == '774-867-5309'
    assert customer.email == 'alice.liddell@gmail.com'
  end

  test "license numbers are unique" do
    assert !Customer.find_by(first_name: 'Alice', last_name: 'Liddell')
    Customer.create(first_name: 'Alice', last_name: 'Liddell', license_number: 'S54318719', phone_number: '774-867-5309', email: 'alice.liddell@gmail.com')
    assert_raise(ActiveRecord::RecordInvalid) do
      Customer.create!(first_name: 'Alice', last_name: 'Liddell', license_number: 'S54318719', phone_number: '774-867-5309', email: 'alice.liddell@gmail.com')
    end
  end

  test "customer can be updated" do
    assert !Customer.find_by(first_name: 'Alice', last_name: 'Liddell')
    Customer.create(first_name: 'Alice', last_name: 'Liddell', license_number: 'S54318719', phone_number: '774-867-5309', email: 'alice.liddell@gmail.com')
    Customer.update(Customer.find_by(first_name: 'Alice', last_name: 'Liddell').id, :phone_number => '999-999-9999')
    assert Customer.find_by(first_name: 'Alice', last_name: 'Liddell').phone_number == '999-999-9999'
  end

  test "customer can be deleted" do
    assert !Customer.find_by(first_name: 'Alice', last_name: 'Liddell')
    Customer.create(first_name: 'Alice', last_name: 'Liddell', license_number: 'S54318719', phone_number: '774-867-5309', email: 'alice.liddell@gmail.com')
    assert Customer.find_by(first_name: 'Alice', last_name: 'Liddell')
    Customer.destroy Customer.find_by(first_name: 'Alice', last_name: 'Liddell').id
    assert !Customer.find_by(first_name: 'Alice', last_name: 'Liddell')
  end

  test "first name is required" do
    assert !Customer.create(last_name: 'Liddell', license_number: 'S54318719', phone_number: '774-867-5309', email: 'alice.liddell@gmail.com').valid?
  end

  test "last name is required" do
    assert !Customer.create(first_name: 'Alice', license_number: 'S54318719', phone_number: '774-867-5309', email: 'alice.liddell@gmail.com').valid?
  end

  test "license is required" do
    assert !Customer.create(first_name: 'Alice', last_name: 'Liddell', phone_number: '774-867-5309', email: 'alice.liddell@gmail.com').valid?
  end

  test "phone numbers or emails are not required" do
    assert Customer.create(first_name: 'Alice', last_name: 'Liddell', license_number: 'S54318719').valid?
  end
end
