class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.string :id
      t.date :reserve_date
      t.time :reserve_time
      t.string :name
      t.string :pax
      t.string :table
      t.string :phone_no
      t.string :remarks
      t.int :location

      t.timestamps
    end
  end
end
