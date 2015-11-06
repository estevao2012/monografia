class CreateViaCaracteristics < ActiveRecord::Migration
  def change
    create_table :via_caracteristics do |t|
    	t.string :name
    	t.string :description
    	t.references :via_caracteristic_categorys
    	t.st_point :geom, geographic: true
      t.timestamps null: false
    end
  end
end
