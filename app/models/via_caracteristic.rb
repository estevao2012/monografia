class ViaCaracteristic < ActiveRecord::Base
	
	belongs_to :rodovia
	belongs_to :via_caracteristic_category, class_name: "ViaCaracteristicCategory",
                        									foreign_key: "via_caracteristic_categorys_id"

	attr_accessor :coord_y, :coord_x, :coord_x_b, :coord_y_b

	def generate_geom

		if self.coord_x && self.coord_y 

			mgeom_a = RGeo::Geographic.spherical_factory(srid: 4326).point(self.coord_x, self.coord_y)
			mgeom_b = RGeo::Geographic.spherical_factory(srid: 4326).point(self.coord_x_b, self.coord_y_b)

			geom_a = get_point_closes_road mgeom_a
			geom_b = get_point_closes_road mgeom_b			

			process_distance(geom_a, geom_b)

		end
	end

	def process_distance geom_a, geom_b

		dis_a = get_distance(geom_a)
		dis_b = get_distance(geom_b)

		if dis_a <= dis_b
			self.geom     = geom_a
			self.geom_b   = geom_b
			self.distance = dis_a
		else
			self.geom_b       = geom_a
			self.geom 	      = geom_b
			self.distance_end = dis_b
		end

		get_km
	end

	def get_point_closes_road geom		
		sql 			= "SELECT ST_AsText(ST_ClosestPoint(
								    '#{self.rodovia.geom}',
								    '#{geom}'
								));"

		result 		= ActiveRecord::Base.connection.execute(sql)
		row 		  = result.first
		row["st_astext"]
	end

	def get_distance point
		sql 					= "SELECT ST_line_locate_point(
									    ST_LineMerge('#{self.rodovia.geom}'),'#{point}'
										);"
		result  			= ActiveRecord::Base.connection.execute(sql)
		row 					= result.first
	  row["st_line_locate_point"]
	end

	def get_km

		sql 				= "SELECT ST_Length(cast('#{self.rodovia.geom}' as geography))/1000 AS km_roads;"
		result  		= ActiveRecord::Base.connection.execute(sql)
		row 				= result.first

		self.km 		= (row["km_roads"].to_f * self.distance.to_f)
		self.km_end = (row["km_roads"].to_f * self.distance_end.to_f)
	end

end
