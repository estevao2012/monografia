class AddColumnDistanceFromBaseRodToViaCaracteristic < ActiveRecord::Migration
  def change
    add_column :via_caracteristics, :distance, :float
    add_column :via_caracteristics, :km, :float
  end
end
