class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.integer :state_id
      t.string :name
      t.string :code
      t.text :description
      t.timestamps
      t.integer :status,:limit => 1 
    end
  end
end
