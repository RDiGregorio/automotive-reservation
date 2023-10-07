class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.date :date, null: false
      t.time :time, null: false
      t.text :description, null: false
      t.string :status, null: false
      t.integer :duration_hours, null: false
      t.timestamps
    end
  end
end
