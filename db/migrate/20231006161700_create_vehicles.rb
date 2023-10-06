class CreateVehicles < ActiveRecord::Migration[7.1]
  def change
    create_table :vehicles do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :make, null: false
      t.string :model, null: false
      t.string :color, null: false
      t.string :registration_number, null: false

      t.timestamps
    end
  end
end
