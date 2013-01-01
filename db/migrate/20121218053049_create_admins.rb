class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password
      t.string :status
      t.string :current_ip

      t.timestamps
    end
  end
end
