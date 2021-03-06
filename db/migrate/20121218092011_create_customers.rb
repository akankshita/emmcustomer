class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.integer :customer_id
      t.string :name
      t.string :email
      t.integer :licence_id
      t.string :status
      t.string :city
      t.string :country
      t.string :postalcode
      t.string :phone
      t.string :phone_code
      t.string :heroku_url
      t.string :heroku_username
      t.string :heroku_password
      t.string :git_url
      t.string :amazon_url
      t.string :db_host
      t.string :db_name
      t.string :db_username
      t.string :db_password
      t.string :db_port
      

      t.timestamps
    end
  end
end
