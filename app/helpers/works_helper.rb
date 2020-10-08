module WorksHelper

  def group_work(work)
    punet = work.user.works.select { |w| w.persisted? && w.start.to_date == work.start.to_date}
    if punet.count != 1 
      if punet.first.group == nil
        group = Group.new(user: work.user)
        punet.each {|p| p.group = group; p.part_group = true; p.save}
        group.save
      else
        group = punet.first.group
        work.group = group
        work.part_group = true
        work.save
      end 
    end
  end

  def import_it(file)
    if File.extname(file.path) == ".xls"
      data = Roo::Spreadsheet.open(file.path, extension: :xls) 
    else
      data = Roo::Spreadsheet.open(file.path, extension: :xlsx) 
    end
    pushim_dates = Pushim.all
    users = []
    time = ""
    prev = ""
    status = ""
    work = 0
    unfinished = false
    breaks = 0
    breake = 0
    breakt = 0
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

      user = User.find_by(idnum: row[2-i])

      if user == nil
        import_it_us(file)
        user = User.find_by(idnum: row[2-i])
      end
      unless user.sales == 0
        user.sales = 0
        user.save
      end
      unless users.include? "#{user.name}(#{user.idnum})"
        users << "#{user.name}(#{user.idnum})"
      end
      time = row[5-i]
      status = row[6-i].strip

      if @current_admin.lang == "Anglisht"
        if status == "Hyrje" or status == "Pauza 1 Hyrje" or status == "Pauza 2 Hyrje" or status == "Pauza 1 Dalje" or status == "Pauza 2 Dalje" or status == "Dalje"
          flash[:danger] = "File eshte ne Shqip. Nese deshironi ta importoni, ndryshoni gjuhen tek admini."
          return
        end
        if prev == ""
          if status == "IN" or status == "Break IN"
            work = Work.new(user: user, start: time)
            prev = work
            unfinished = true
          end
        else
          if status == "IN" 
            if prev.user.idnum == user.idnum
              if work == 0
                work = Work.new(user: user, start: time)
                prev = work
              else
                next
              end
            else
              work = Work.new(user: user, start: time)
              prev = work
            end

            unfinished = true
          elsif status == "Break IN"
            if work == 0
              work = Work.new(user: user, start: time)
              prev = work
              next
            end

            if breaks == 0
              breaks = DateTime.parse(time)
            else 
              if breake == 0 
                breake = DateTime.parse(time)
              else
                next
              end
            end

            unfinished = true
          elsif status == "Break Out"
            if work == 0
              work = Work.new(user: user, start: time)
              prev = work
              next
            end
            if breaks != 0
              breake = DateTime.parse(time)
            else 
              breaks = DateTime.parse(time)
            end

            unfinished = true
          elsif status == "OUT"
            if work == 0
              next
            else
              work.end = time
              unless breaks == 0 || breake == 0
                breakt = (breake - breaks)/60
              end
              if breakt > 40
                work.break = breakt
              end
              pushim_dates.each do |p|
                if p.date == work.start.to_date
                  work.pushim = true
                  break
                end
              end
              case work.start.strftime("%A")
              when "Monday"
                work.pushim = true if user.pushimet[0]
              when "Tuesday"
                work.pushim = true if user.pushimet[1]
              when "Wednesday"
                work.pushim = true if user.pushimet[2]
              when "Thursday"
                work.pushim = true if user.pushimet[3]
              when "Friday"
                work.pushim = true if user.pushimet[4]
              when "Saturday"
                work.pushim = true if user.pushimet[5]
              when "Sunday"
                work.pushim = true if user.pushimet[6]
              else
                work.pushim = false
              end
              work.save
              user = 0
              time = 0
              status = 0
              breaks = 0
              breake = 0
              breakt = 0
              prev = work
              group_work(work)
              work = 0
              next
            end

            unfinished = false
          end
        end
      else
        if status == "IN" or status == "Break IN" or status == "Break Out" or status == "OUT"
          flash[:danger] = "File eshte ne Anglisht. Nese deshironi ta importoni, ndryshoni gjuhen tek admini."
          return
        end
        if prev == ""
          if status == "Hyrje" or status == "Pauza 1 Hyrje" or status == "Pauza 2 Hyrje"
            work = Work.new(user: user, start: time)
            prev = work
            unfinished = true
          end
        else
          if status == "Hyrje" 
            if prev.user.idnum == user.idnum
              if work == 0
                work = Work.new(user: user, start: time)
                prev = work
              else
                next
              end
            else
              work = Work.new(user: user, start: time)
              prev = work
            end

            unfinished = true
          elsif status == "Pauza 1 Hyrje" or status == "Pauza 2 Hyrje"
            if work == 0
              work = Work.new(user: user, start: time)
              prev = work
              next
            end

            unfinished = true
          elsif status == "Pauza 1 Dalje" or status == "Pauza 2 Dalje"
            if work == 0
              work = Work.new(user: user, start: time)
              prev = work
              next
            end

            unfinished = true
          elsif status == "Dalje"
            if work == 0
              next
            else
              work.end = time
              unless breaks == 0 || breake == 0
                breakt = (breake - breaks)/60
              end
              if breakt > 40
                work.break = breakt
              end
              pushim_dates.each do |p|
                if p.date == work.start.to_date
                  work.pushim = true
                  break
                end
              end
              case work.start.strftime("%A")
              when "Monday"
                work.pushim = true if user.pushimet[0]
              when "Tuesday"
                work.pushim = true if user.pushimet[1]
              when "Wednesday"
                work.pushim = true if user.pushimet[2]
              when "Thursday"
                work.pushim = true if user.pushimet[3]
              when "Friday"
                work.pushim = true if user.pushimet[4]
              when "Saturday"
                work.pushim = true if user.pushimet[5]
              when "Sunday"
                work.pushim = true if user.pushimet[6]
              else
                work.pushim = false
              end
              work.save
              user = 0
              time = 0
              status = 0
              breaks = 0
              breake = 0
              breakt = 0
              prev = work
              group_work(work)
              work = 0
              next
            end

            unfinished = false
          end
        end
      end
    end
    text = "Jane shtuar te dhena per punemarresit: #{users.join(", ")}"

    Log.create(admin: @current_admin, text: text)
  end

  def import_it_online(file)
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
      if idx == 0
        next
      end
      user = User.find_by(name: row[1] + " " + row[2])
      if user == nil
        next
      end
      if dep == "1"
        i = 8
      elsif dep == "2"
        i = 16
      elsif dep == "3"
        i = 25
      elsif dep == "4"
        i = 33
      elsif dep == "5"
        i = 41
      elsif dep == "6"
        i = 55
      elsif dep == "7"
        i = 65 
      elsif dep == "8"
        i = 73
      elsif dep == "9"
        i = 81
      elsif dep == "10"
        i = 89
      elsif dep == "11"
        i = 97
      elsif dep == "12"
        i = 113
      end
      if dep != "12"
        next
      end

      shrow = []
      te_dhenat = []

      row.each do |r|
        n = 0
        if row[0..5].include? r
          i += 1
          next
        end
        if r == nil
          i+=1
          next
        end
        n+=1
        i+=1
        if n==4
          r = data.excelx_value(idx, i)
        end
        shrow << [r,i]
      end
      te_dhenat << shrow
      $val << "#{idx} - #{te_dhenat}"


      case work.start.strftime("%A")
      when "Monday"
        work.pushim = true if user.pushimet[0]
      when "Tuesday"
        work.pushim = true if user.pushimet[1]
      when "Wednesday"
        work.pushim = true if user.pushimet[2]
      when "Thursday"
        work.pushim = true if user.pushimet[3]
      when "Friday"
        work.pushim = true if user.pushimet[4]
      when "Saturday"
        work.pushim = true if user.pushimet[5]
      when "Sunday"
        work.pushim = true if user.pushimet[6]
      else
        work.pushim = false
      end
      work.save
    end
    text = "Jane shtuar te dhena per punemarresit: #{users.join(", ")} (test online)"

    Log.create(admin: @current_admin, text: text)
  end
end
