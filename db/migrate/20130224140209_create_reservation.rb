class CreateReservation < ActiveRecord::Migration
  def change
    create_table :reservation, { :primary_key => 'id' } do |t|
      t.string :id, :null => false, :limit => 40
      t.date :reserve_date, :null => false
      t.time :reserve_time, :null => false
      t.string :name, :null => false, :limit => 30
      t.string :pax, :null => false, :limit => 10
      t.string :table, :null => false, :limit => 5
      t.string :phone_no, :null => false, :limit => 15
      t.string :remarks, :null => false, :limit => 30
      t.integer :location, :null => false
    end
    
    change_column :reservation, :id, :string, :limit => 40
  end
end
