class ViaCaracteristicsController < ApplicationController

	before_filter :url_params

	def new
		@via_caracteristic = ViaCaracteristic.new rodovia: @rodovia
	end

	def create
		@via_caracteristic 				 = ViaCaracteristic.new(via_caracteristic_params)
		@via_caracteristic.rodovia = @rodovia
		@via_caracteristic.generate_geom
		@via_caracteristic.save
	end

	private

		def url_params
			@rodovia 					 = Rodovia.find(params[:rodovia_id])
			@via_caracteristic = ViaCaracteristic.find(params[:id]) if params[:id]
		end

		def via_caracteristic_params
			params.require(:via_caracteristic).permit(:name, :description, :coord_y, :coord_y_b, :via_caracteristic_categorys_id, :rodovia_id, :coord_x, :coord_x_b)
		end
	
end
