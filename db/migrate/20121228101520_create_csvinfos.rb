class CreateCsvinfos < ActiveRecord::Migration
  def change
    create_table :csvinfos do |t|
      t.integer :customer_id
      t.string :name
      t.string :verified
      t.string :loaded
      t.string :totaldata
      t.string :view
      t.string :status
      t.datetime :upload_date
      t.timestamps
    end
  end
end
