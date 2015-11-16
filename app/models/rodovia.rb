class Rodovia < ActiveRecord::Base
	has_many :via_caracteristics


	def json_geom
		factory = RGeo::GeoJSON::EntityFactory.instance
		feature = factory.feature(self.geom, self.br, {br: self.br, id: self.id})
		json_edu = RGeo::GeoJSON.encode feature
		json_edu.to_json
	end
end
