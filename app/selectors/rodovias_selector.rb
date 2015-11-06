class RodoviasSelector
	def self.all
		Rodovia.find_by_sql("SELECT ST_Union(\"rodovias\".\"geom\") as \"geom\", \"rodovias\".\"br\" FROM \"rodovias\" GROUP BY br")
	end

	def self.first_by_br br
		Rodovia.find_by_sql("SELECT ST_Union(\"rodovias\".\"geom\") as \"geom\", \"rodovias\".\"br\" FROM \"rodovias\" WHERE \"rodovias\".\"br\" = '#{br}' GROUP BY br")
	end


end