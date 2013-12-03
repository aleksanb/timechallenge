class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.integer :building_id
      t.string :nr
      t.string :name
      t.string :address
      t.integer :built_year
      t.integer :campus_id

      t.timestamps
    end
  end
end
