class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.date :date
      t.time :time
      t.text :description
      t.string :status

      t.timestamps
    end
  end
end
