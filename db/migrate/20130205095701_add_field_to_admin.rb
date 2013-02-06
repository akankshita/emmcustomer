class AddFieldToAdmin < ActiveRecord::Migration
  def self.up
      add_column :admins, :email2,    :string
      add_column :admins, :country_id, :integer
      add_column :admins, :state_id,    :integer
      add_column :admins, :city_id,   :integer
      add_column :admins, :zip_code,    :string
      add_column :admins, :phone, :string
      add_column :admins, :phone1,    :string
      add_column :admins, :mobile,   :string
  end
  def self.down
      remove_column :admins, :email2    
      remove_column :admins, :country_id
      remove_column :admins, :state_id
      remove_column :admins, :city_id
      remove_column :admins, :zip_code
      remove_column :admins, :phone
      remove_column :admins, :phone1
      remove_column :admins, :mobile

  end
end
