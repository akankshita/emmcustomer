class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.integer :country_id
      t.string :name
      t.string :code
      t.text :description
      t.timestamps
      t.integer :status,:limit => 1
      
    end
  end
end
