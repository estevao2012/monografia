# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).


#
# Examples:
#
#   cities = City.create([{ name: "Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# begin
# 	puts "Creating municipios_raw"
# 	script_lines = File.read('db/municipios.sql')
# 	connection = ActiveRecord::Base.connection();
# 	connection.execute(script_lines)
# rescue Exception => e
# 	puts "Something went wrong when creating country data: #{e.message}"
# end

# puts "Creating rodovias"
# result = ActiveRecord::Base.connection.execute("SELECT * from municipios")
# result.each do |row|
#    City.find_or_create_by!( nome: row["nome"] , geom: row["geom"], uf: row["uf"], 
#    													populacao: row["populacao"], pib: row["pib"], estado_id: row["estado_id"],
#    													codigo_ibg: row["codigo_ibg"] )
# end

# begin
# 	puts "Creating rodovias_raw"
# 	script_lines = File.read('db/SHAPEFILE.sql')
# 	connection = ActiveRecord::Base.connection();
# 	connection.execute(script_lines)
# rescue Exception => e
# 	puts "Something went wrong when creating country data: #{e.message}"
# end


# puts "Creating rodovias"
# result = ActiveRecord::Base.connection.execute("SELECT br, ST_Union(geom) as geom from rodovias_raw GROUP BY br")
# result.each do |row|
#    Rodovia.find_or_create_by!(br: row["br"] , geom: row["geom"] )
# end

entroncamento = ViaCaracteristicCategory.find_or_create_by name: "Entroncamento", importance: 0
cidade        = ViaCaracteristicCategory.find_or_create_by name: "Cidade", importance: 0
ViaCaracteristicCategory.find_or_create_by name: "Pedágio", importance: 1
ViaCaracteristicCategory.find_or_create_by name: "Categoria Foursquare", importance: 1
ViaCaracteristicCategory.find_or_create_by name: "Acostamento", importance: 2
ViaCaracteristicCategory.find_or_create_by name: "Placa de sinalização", importance: 3
ViaCaracteristicCategory.find_or_create_by name: "Redutor de Velocidade", importance: 3
ViaCaracteristicCategory.find_or_create_by name: "Velocidades Máxima", importance: 3
ViaCaracteristicCategory.find_or_create_by name: "Outra Caracteristica", importance: 4
ViaCaracteristicCategory.find_or_create_by name: "Capacidade Máxima de Carga", importance: 4
ViaCaracteristicCategory.find_or_create_by name: "Pontos de referência adjacente à via", importance: 4

# User.create!({:email => "admin@admin.com", :password => "12345678", :password_confirmation => "12345678" }) unless User.find_by email: "admin@admin.com"

ViaCaracteristic.delete_all
# geographic_factory = RGeo::Geographic.spherical_factory(:srid => 4326)
projection 				 = RGeo::CoordSys::Proj4.new( "+proj=utm +zone=21 +units=m")
geographic_factory = RGeo::Geographic.projected_factory(projection_proj4: projection)

puts "Creating entrocamentos e cidades"
Rodovia.all.each do |p_rodovia|

	City.all.each do |city|	

		begin
			
			result  			 			= ActiveRecord::Base.connection.execute("SELECT ST_AsText( ST_Intersection('#{p_rodovia.geom}', '#{city.geom}') ) as city_intersect")
			city_intersect 			= result.first
			geom_city_intersect = geographic_factory.parse_wkt(city_intersect['city_intersect'])
			
			if geom_city_intersect.as_text != "GEOMETRYCOLLECTION EMPTY"
				if geom_city_intersect.geometry_type == RGeo::Feature::MultiLineString

					puts geom_city_intersect.geometry_type

					first_linestring = geom_city_intersect.geometry_n(0)
					last_linestring  = geom_city_intersect.geometry_n(geom_city_intersect.size-1)

					entry_point = first_linestring.point_n(0)
					exit_point  = last_linestring.point_n( last_linestring.num_points-1 )

					via_caracteristic_params 							 = {}
					via_caracteristic_params[:name] 			 = "Rodovia BR#{p_rodovia.br} cruza a cidade #{city.nome} - #{city.uf}"
					via_caracteristic_params[:description] = "Rodovia BR#{p_rodovia.br} cruza a cidade #{city.nome} - #{city.uf}"

					via_caracteristic 				 										= ViaCaracteristic.new(via_caracteristic_params)
					via_caracteristic.via_caracteristic_category  = cidade
					via_caracteristic.rodovia 										= p_rodovia
					via_caracteristic.process_distance entry_point, exit_point
					via_caracteristic.save

					puts via_caracteristic.name

				elsif geom_city_intersect.geometry_type == RGeo::Feature::LineString

					puts geom_city_intersect.geometry_type

					entry_point = geom_city_intersect.point_n(0)
					exit_point  = geom_city_intersect.point_n( geom_city_intersect.num_points-1 )

					via_caracteristic_params 							 = {}
					via_caracteristic_params[:name] 			 = "Rodovia BR#{p_rodovia.br} cruza a cidade #{city.nome} - #{city.uf}"
					via_caracteristic_params[:description] = "Rodovia BR#{p_rodovia.br} cruza a cidade #{city.nome} - #{city.uf}"

					via_caracteristic 				 										= ViaCaracteristic.new(via_caracteristic_params)
					via_caracteristic.via_caracteristic_category  = cidade
					via_caracteristic.rodovia 										= p_rodovia
					via_caracteristic.process_distance entry_point, exit_point
					via_caracteristic.save

					puts via_caracteristic.name

				end
			end

		rescue => e
			p e.message
		end
	end


	Rodovia.all.each do |rodovia|
		if p_rodovia != rodovia
			begin

				result  = ActiveRecord::Base.connection.execute("SELECT ST_AsText( ST_Intersection('#{p_rodovia.geom}', '#{rodovia.geom}') ) as overlap")
				a 		  = result.first

				my_geom = geographic_factory.parse_wkt(a['overlap'])


				if my_geom.geometry_type == RGeo::Feature::MultiPoint || my_geom.geometry_type == RGeo::Feature::Point

					p my_geom.geometry_type

					if my_geom.geometry_type == RGeo::Feature::MultiPoint
						geom 	 = my_geom.geometry_n(0) 
						geom_b = my_geom.geometry_n(0)
					else
						geom 	 = my_geom
						geom_b = my_geom
					end 

					via_caracteristic_params 							 = {}
					via_caracteristic_params[:name] 			 = "Entroncamento com rodovia BR#{rodovia.br}"
					via_caracteristic_params[:description] = "Entroncamento com rodovia BR#{rodovia.br}"

					via_caracteristic 				 										= ViaCaracteristic.new(via_caracteristic_params)
					via_caracteristic.via_caracteristic_category  = entroncamento
					via_caracteristic.rodovia 										= p_rodovia
					via_caracteristic.process_distance(geom, geom_b)
					via_caracteristic.save

					puts via_caracteristic.name
				else 
					# p "nothing"
				end
			rescue => e
				p e.message
			end
			
		end
	end


end

