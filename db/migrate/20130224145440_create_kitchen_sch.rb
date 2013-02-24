class CreateKitchenSch < ActiveRecord::Migration
  def change
    create_table :kitchen_sch, { :primary_key => 'id' } do |t|
      t.string :id, :null => false, :limit => 40
      t.integer :category, :null => false
      t.string :name, :null => false, :limit => 30
      t.string :position, :null => false, :limit => 30
      t.integer :location, :null => false
      t.integer :week, :null => false
      t.integer :year, :null => false
      t.string :mon, :null => false, :limit => 1
      t.string :tue, :null => false, :limit => 1
      t.string :wed, :null => false, :limit => 1
      t.string :thur, :null => false, :limit => 1
      t.string :fri, :null => false, :limit => 1
      t.string :sat, :null => false, :limit => 1
      t.string :sun, :null => false, :limit => 1
    end
    
    change_column :kitchen_sch, :id, :string, :limit => 40
  end
end
