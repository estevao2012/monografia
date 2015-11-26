class RodoviasController < ApplicationController
	def show
		@importance 				= importance_params
		@categories 				= ViaCaracteristicCategory.all
		@rodovia 						= Rodovia.find(params[:id])
		@used_categories		= params[:categories] if params[:categories]
		@used_categories  ||= @categories.map { |e| e.id }

		@via_caracteristics = @rodovia.via_caracteristics
																	.joins(:via_caracteristic_category)
																	.where("via_caracteristic_categorys.importance <= #{@importance}")
																	.where("via_caracteristic_categorys.id IN (#{@used_categories.join(',')})") 

		render layout: false
	end

	private 

	def importance_params
		importance   = params[:importance].to_i if params[:importance]
		importance ||= 0

		importance = 0 if importance < 0
		importance = 10 if importance > 5
		importance 
	end
end
