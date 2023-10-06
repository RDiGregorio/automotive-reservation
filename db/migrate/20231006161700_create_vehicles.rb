class CreateVehicles < ActiveRecord::Migration[7.1]
  def change
    create_table :vehicles do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :make
      t.string :model
      t.string :color
      t.string :registration_number

      t.timestamps
    end
  end
end
