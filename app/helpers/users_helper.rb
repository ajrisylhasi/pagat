module UsersHelper
	def import_it_us(file)
		if File.extname(file.path) == ".xls"
			data = Roo::Spreadsheet.open(file.path, extension: :xls) 
		else
			data = Roo::Spreadsheet.open(file.path, extension: :xlsx) 
		end
		users = []
		i = 0
		data.each_with_index do |row, idx|

			if idx == 0
				if row[0] == "Serial No." 
					i = 0
				elsif row[0] == "Department"
					i = 1
				elsif row[0] == "User No."
					i = 2
				end
				next
			end
			name = row[4-i]
			idnum = row[2-i]
			if !(User.find_by(idnum: idnum).nil?)
				next
			else
				@user = User.create(name: name, idnum: idnum)
				SpecificContract.create(user: @user)
			end
			users << "#{name}(#{idnum})"
		end
		Log.create(admin: @current_admin, text: "U shtuan punetoret: #{users.join(", ")}")
	end

	def import_it_us_online(file)
		if File.extname(file.path) == ".xls"
			data = Roo::Spreadsheet.open(file.path, extension: :xls) 
		else
			data = Roo::Spreadsheet.open(file.path, extension: :xlsx) 
		end
		users = []
		i = 0
		data.each_with_index do |row, idx|

			if idx == 0
				if row[0] == "Serial No." 
					i = 0
				elsif row[0] == "Department"
					i = 1
				elsif row[0] == "User No."
					i = 2
				end
				next
			end
			name = row[4-i]
			idnum = row[2-i]
			if !(User.find_by(idnum: idnum).nil?)
				next
			else
				@user = User.create(name: name, idnum: idnum)
				SpecificContract.create(user: @user)
			end
			users << "#{name}(#{idnum})"
		end
		Log.create(admin: @current_admin, text: "U shtuan punetoret: #{users.join(", ")}")
	end

	def users_month(user, date_from, date_to)

		unless date_from == ""|| date_to == ""|| date_from == nil || date_to == nil
			@works = user.works.select { |w| w.start.to_date >= @date_from && w.start.to_date <= @date_to}
			@groups = user.groups.select { |g| next if g.works.count == 0; g.works.first.start.to_date >= @date_from && g.works.last.start.to_date <= @date_to}
		end
	end

	def pushim_dates(datat)
		unless datat == nil
			datat = datat.split(",")
			datat.each do |d|
				works = @works.select { |w| w.start.strftime("%m/%d/%Y") == d}
				works.each do |w|
					if w.pushim == false
						w.pushim = true
					else
						w.pushim = false
					end
					w.save
				end
			end
			Log.create(admin: @current_admin, text: "U ndryshuan ditet e pushimit per punemarresin #{@works.first.user.name}(#{@works.first.user.idnum})")
			redirect_to @works.first.user
		end

	end

	def import_personal_number(file)
		if File.extname(file.path) == ".xls"
			data = Roo::Excel.new(file.path, extension: :xls) 
		else
			data = Roo::Excelx.new(file.path, extension: :xlsx) 
		end
		pushim_dates = Pushim.all
		users = []
		work = 0

		$val = []
		data.each_with_index do |row, idx|
			i = 0
			if idx <= 1
				next
			end
			user = User.find_by(idnum: row[0].strip)
			user = User.find_by(name: "#{row[1]}".gsub(" ","") + " " + "#{row[2]}".gsub(" ","")) if user == nil
			if user == nil
				next
			else
				if row[3] != "" || row[3] != nil
					user.personal_number = row[3]
				end
				if row[4] != "" || row[4] != nil
					user.email = row[4]
				end
				if row[5].to_f != 0 || row[5] != nil
					user.salary = row[5]
				end
				if row[6].to_i != 0 || row[6] != nil
					user.contract = row[6]
				end
			end
		end
	end

end