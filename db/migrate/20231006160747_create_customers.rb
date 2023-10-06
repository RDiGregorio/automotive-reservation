class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.string :first_name
      t.string :last_name
      t.string :license_number
      t.string :phone_number
      t.string :email

      t.timestamps
    end
  end
end
