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
		users_new = []
		users_edit = []
		work = 0

		$val = []
		data.each_with_index do |row, idx|
			i = 0
			if idx == 0
				next
			end
			user = User.find_by(idnum: row[0].gsub(" ",""))
			if user == nil
				user = User.find_by(name: "#{row[1]}".gsub(" ","") + " " + "#{row[2]}".gsub(" ",""))
			end
			if user == nil
				user = User.create(idnum: "#{row[0].strip}", name: "#{row[1]}".gsub(" ","") + " " + "#{row[2]}".gsub(" ",""), personal_number: "#{row[3].to_i}".gsub(" ",""), email: "#{row[4]}".gsub(" ",""), salary: row[5].to_f, contract: row[6].to_i)
				SpecificContract.create(user: user)
				row[7] = "" if row[7] == nil
				ditet = row[7].split(",")
				ditet = [] if ditet == nil
				ditet.each do |d|
					if d.strip == "E Hënë"
						user.pushimet[0] = true
					elsif d.strip == "E Martë"
						user.pushimet[1] = true
					elsif d.strip == "E Mërkurë"
						user.pushimet[2] = true
					elsif d.strip == "E Enjte"
						user.pushimet[3] = true
					elsif d.strip == "E Premte"
						user.pushimet[4] = true
					elsif d.strip == "E Shtunë"
						user.pushimet[5] = true
					elsif d.strip == "E Diel"
						user.pushimet[6] = true
					end
				end
				users_new << "#{user.name}(#{user.idnum})"
				user.save
				next
			end
			if user == nil
				next
			else
				if row[3] != "" && row[3] != nil
					user.personal_number = "#{row[3]}"
				end
				if row[4] != "" && row[4] != nil
					user.email = "#{row[4]}"
				end
				if row[5].to_f != 0 && row[5] != nil
					user.salary = row[5].to_f
				end
				if row[6].to_i != 0 && row[6] != nil
					user.contract = row[6].to_i
				end
				if row[7] != "" && row[7] != nil
					ditet = "#{row[7]}".split(",")
					ditet.each do |d|
						if d.strip == "E Hënë"
							user.pushimet[0] = true
						elsif d.strip == "E Martë"
							user.pushimet[1] = true
						elsif d.strip == "E Mërkurë"
							user.pushimet[2] = true
						elsif d.strip == "E Enjte"
							user.pushimet[3] = true
						elsif d.strip == "E Premte"
							user.pushimet[4] = true
						elsif d.strip == "E Shtunë"
							user.pushimet[5] = true
						elsif d.strip == "E Diel"
							user.pushimet[6] = true
						end
					end
				end
				users_edit << "#{user.name}(#{user.idnum})"
				user.save
			end
		end
		if users_new
			Log.create(admin: @current_admin, text: "U shtuan punetoret: #{users_new.join(", ")}")
		end
		if users_edit
			Log.create(admin: @current_admin, text: "U ndryshuan punetoret: #{users_edit.join(", ")}")
		end
	end

end