class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :title
      t.timestamps
      t.integer :status,:limit => 1
    end
  end
end
