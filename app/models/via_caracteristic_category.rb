class ViaCaracteristicCategory < ActiveRecord::Base
	has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/outrascaracteristicas.jpg"
	validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

	has_many :via_caracteristics

	def to_s
		self.name
	end
end
