class HomeController < ApplicationController
	def index
		minX = params[:left_top]
		minY = params[:right_top]
		maxX = params[:bottom_right]
		maxY = params[:bottom_left]
		exclude = params[:exclude]

		if minX
			factory 			 = RGeo::Geographic.spherical_factory(srid: 4326)
			
			point1 				 = factory.point(minX, minY)
			point2 				 = factory.point(minX, maxY)
			point3 				 = factory.point(maxX, maxY)
			point4 				 = factory.point(maxX, minY)

			line_string  	 = factory.line_string([point1, point2, point3, point4])
			poligon 			 = factory.polygon(line_string)

			sql 					= "ST_Contains('#{poligon}', rodovias.geom)"

			ids_exclude  	= exclude.split(",").map{ |e| e.to_i unless e.empty?}

			@locals = Rodovia.where(sql).where.not(id: ids_exclude)
			
		else
			@locals = Rodovia.all.limit(10)
		end
	end

	def get_geom_by_br 
		br = params[:br]

		factory = RGeo::GeoJSON::EntityFactory.instance
		single  = Rodovia.find_by br: br
		feature = factory.feature(single.geom, single.br, {br: single.br, id: single.id})
		json_edu = RGeo::GeoJSON.encode feature

		respond_to do |format|
		  format.json  { render json: json_edu.to_json }
		end
	end

	def get_geom_by_id
		br = params[:item_id]

		factory = RGeo::GeoJSON::EntityFactory.instance
		single  = ViaCaracteristic.find br
		feature = factory.feature(single.geom, single.id, {br: single.name, id: single.id})
		json_edu = RGeo::GeoJSON.encode feature

		respond_to do |format|
		  format.json  { render json: json_edu.to_json }
		end
	end
end
