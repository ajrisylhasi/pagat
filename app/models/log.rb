class Log < ApplicationRecord
	belongs_to :admin, optional: true
	belongs_to :user, optional: true

	after_save { if self.admin != nil
					update_column(:kush, self.admin.name)
				end
		}

	def koha
		self.created_at + 60*60*2
	end
end
