class Kerkesa < ApplicationRecord
	has_one_attached :file
	belongs_to :user

	def numri_diteve
		start = self.data_fillimit
		endi = self.data_mbarimit
		no_work = []
		i = 1
		self.user.pushimet.each do |p|
			if p == "true"
				if i == 7
					no_work << 0
					next
				end
				no_work << i
			end
			i+=1
		end
		pushim_dates = Pushim.all
		result = (start..endi).to_a.select {|k| !(no_work.include?(k.wday))}
		result = result.select { |k| !(pushim_dates.any? { |p| p.date == k})}
		return result.count
	end

	def numri_diteve_spec(date)
		start = self.data_fillimit
		endi = date
		no_work = []
		i = 1
		self.user.pushimet.each do |p|
			if p == "true"
				if i == 7
					no_work << 0
					next
				end
				no_work << i
			end
			i+=1
		end
		pushim_dates = Pushim.all
		result = (start..endi).to_a.select {|k| !(no_work.include?(k.wday))}
		result = result.select { |k| !(pushim_dates.any? { |p| p.date == k})}
		return result.count
	end
end
