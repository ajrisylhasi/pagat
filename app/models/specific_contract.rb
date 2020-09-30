class SpecificContract < ApplicationRecord
	belongs_to :user

	before_save :default

	def default
		self.monday ||= 0
		self.tuesday ||= 0
		self.wednesday ||= 0
		self.thursday ||= 0
		self.friday ||= 0 
		self.saturday ||= 0
		self.sunday ||= 0
	end

	def total
		self.monday + self.tuesday + self.wednesday + self.thursday + self.friday + self.saturday + self.sunday
	end
end
