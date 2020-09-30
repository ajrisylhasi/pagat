class Group < ApplicationRecord
	has_many :works
	belongs_to :user

	def total
		total = 0
        self.works.each {|p| total += p.total}
        return total
    end

	def extra
		if self.works.first.pushim
			return 0
		end
		if self.user.shkurt_pushim
			new_total = self.total+10
		else
			new_total = self.total
		end
		if self.user.spec_contract
			if self.works.first.start.to_date.monday?
				if self.user.specific_contract.monday == 0
					return self.total
				end
				if (new_total - ((self.user.specific_contract.monday*60)+ 10)) > 0
					return new_total - ((self.user.specific_contract.monday*60)+ 10)
				else
					return 0
				end
			elsif self.works.first.start.to_date.tuesday?
				if self.user.specific_contract.tuesday == 0
					return new_total
				end
				if (new_total - ((self.user.specific_contract.tuesday*60)+ 10)) > 0
					return new_total - ((self.user.specific_contract.tuesday*60)+ 10)
				else
					return 0
				end
			elsif self.works.first.start.to_date.wednesday?
				if self.user.specific_contract.wednesday == 0
					return new_total
				end
				if (new_total - ((self.user.specific_contract.wednesday*60)+ 10)) > 0
					return new_total - ((self.user.specific_contract.wednesday*60)+ 10)
				else
					return 0
				end
			elsif self.works.first.start.to_date.thursday?
				if self.user.specific_contract.thursday == 0
					return new_total
				end
				if (new_total - ((self.user.specific_contract.thursday*60)+ 10)) > 0
					return new_total - ((self.user.specific_contract.thursday*60)+ 10)
				else
					return 0
				end
			elsif self.works.first.start.to_date.friday?
				if self.user.specific_contract.friday == 0
					return new_total
				end
				if (new_total - ((self.user.specific_contract.friday*60)+ 10)) > 0
					return new_total - ((self.user.specific_contract.friday*60)+ 10)
				else
					return 0
				end
			elsif self.works.first.start.to_date.saturday?
				if self.user.specific_contract.saturday == 0
					return new_total
				end
				if (new_total - ((self.user.specific_contract.saturday*60)+ 10)) > 0
					return new_total - ((self.user.specific_contract.saturday*60)+ 10)
				else
					return 0
				end
			elsif self.works.first.start.to_date.sunday?
				if self.user.specific_contract.sunday == 0
					return new_total
				end
				if (new_total - ((self.user.specific_contract.sunday*60)+ 10)) > 0
					return new_total - ((self.user.specific_contract.sunday*60)+ 10)
				else
					return 0
				end
			end
		else
			if (new_total - (((self.user.contract/5)*60)+ 10)) > 0
				return new_total - (((self.user.contract/5)*60)+ 10)
			else
				return 0
			end
		end
	end

	def missing 
		if self.works.first.pushim 
			return 0
		end
		if self.user.spec_contract
			if self.works.first.start.to_date.monday?
				con = self.user.specific_contract.monday*60 + 10
			elsif self.works.first.start.to_date.tuesday?
				con = self.user.specific_contract.tuesday*60 + 10
			elsif self.works.first.start.to_date.wednesday?
				con = self.user.specific_contract.wednesday*60 + 10
			elsif self.works.first.start.to_date.thursday?
				con = self.user.specific_contract.thursday*60 + 10
			elsif self.works.first.start.to_date.friday?
				con = self.user.specific_contract.friday*60 + 10
			elsif self.works.first.start.to_date.saturday?
				con = self.user.specific_contract.saturday*60 + 10
			elsif self.works.first.start.to_date.sunday?
				con = self.user.specific_contract.sunday*60 + 10
			end
		else
			con = self.user.contract/5*60 + 10
		end
		if self.user.shkurt_pushim
			con = con - 10
		end
		if self.total < con
			return con - self.total
		else
			return 0
		end
	end

	def extra_pushim
		if self.works.first.pushim
			total
		else
			0
		end
	end

	def last_work
		self.works.last
	end
end
