class AddColumnPointSequence < ActiveRecord::Migration
  def change
    add_column :via_caracteristics, :geom_b ,:st_point, geographic: true
    add_column :via_caracteristics, :distance_end ,:float
    add_column :via_caracteristics, :km_end ,:float
  end
end
