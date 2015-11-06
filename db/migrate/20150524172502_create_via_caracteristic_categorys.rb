class CreateViaCaracteristicCategorys < ActiveRecord::Migration
  def change
    create_table :via_caracteristic_categorys do |t|
    	t.string :name
    	t.string :description
    	t.integer :importance
      t.timestamps null: false
    end
  end
end
