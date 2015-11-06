class AddColumnViaCaracteristic < ActiveRecord::Migration
  def change
  	add_reference :via_caracteristics, :rodovia, index: true
  end
end
