class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :name
      t.string :code
      t.text :description
      t.integer :status ,:limit => 1
      t.timestamps
    end
  end
end
