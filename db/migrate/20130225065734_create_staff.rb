class CreateStaff < ActiveRecord::Migration
  def change
    create_table :staff, { :primary_key => 'id' } do |t|
      t.string :id, :null => false, :limit => 40
      t.string :name, :null => false, :limit => 30
      t.string :contact_no, :null => false, :limit => 15
      t.integer :status
      t.string :remarks, :limit => 50
    end
    
    change_column :staff, :id, :string, :limit => 40
  end
end
