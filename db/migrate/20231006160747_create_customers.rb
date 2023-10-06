class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :license_number, null: false
      t.string :phone_number
      t.string :email

      t.timestamps
    end
  end
end
