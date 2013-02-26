class CreateJobPosition < ActiveRecord::Migration
  def change
    create_table :job_position, { :primary_key => 'id' } do |t|
      t.string :id, :null => false, :limit => 40
      t.string :name, :null => false, :limit => 30
    end
    
    add_index :job_position, [:name], { :name => 'name', :unique => true }
    change_column :job_position, :id, :string, :limit => 40
  end
end
