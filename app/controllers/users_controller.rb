class UsersController < ApplicationController
  def index
    @i = 0
    @term ||= params[:term] rescue ""
    if @term == "" || @term == nil
      params[:page] ||= (User.all.count/10.0).ceil
      if params[:page] == 0 
        params[:page] = 1
      end
      @users = User.all.sort_by {|u| u.idnum_str}.paginate(:page => params[:page], :per_page=>10)
    else
      @users = User.where("LOWER(name) LIKE ? or LOWER(idnum) LIKE ?", "%#{@term.downcase}%", "%#{@term.downcase}%").sort_by {|u| u.idnum_str}.paginate(:page => params[:page], :per_page=>10)
    end
    @user ||= User.new
    @errors = params[:errors]
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user

      SpecificContract.create(user: @user)
      Log.create(admin: @current_admin, text: "U shtua punemarresi #{@user.name}(#{@user.idnum})")
    else
      @errors = []
      if @user.errors.any?
        @user.errors.full_messages.each do |msg|
          @errors.push msg
        end
      end
      redirect_to users_path(errors: @errors)
    end
  end

  def destroy
    @user= User.find(params[:id])
    name = "#{@user.name}(#{@user.idnum})"
    @user.destroy
    redirect_to users_path
    Log.create(admin: @current_admin, text: "U fshi punemarresi #{name}")
  end

  def edit
    @user = User.find(params[:id]) 
    if params[:ndryshimi_pushimit]
      @user.pushimet = [params[:mon], params[:tue], params[:wed], params[:thur], params[:fri], params[:sat], params[:sun]] 
      @user.save
      redirect_to edit_user_path(@user)                 

      Log.create(admin: @current_admin, text: "U ndryshua perdoruesi #{@user.name}(#{@user.idnum})") 
    end  
  end

  def show
    @user = User.find(params[:id])
    @works = []
    if @user.works.count != 0 
      @works = @user.works.sort_by { |w| [w.start]}
      @groups = @user.groups.select { |w| w.works.count != 0}.sort_by { |w| [w.works.first.start]}
      @total = 0
      @extra_t_para = 0
      @missing_t = 0
      @extra_pushim_t_para = 0
      @extra_t = 0
      @extra_pushim_t = 0
      @missing_t_para = 0
      @shkurt_pushim = false
      @sales ||= 0
      if params[:ndrysho_pagen]
        @date_from = Date.parse(params[:date_from]) rescue ""
        @date_to = Date.parse(params[:date_to]) rescue ""
        users_month(@user, @date_from, @date_to)
        pushim_dates(@datat)
        if @works.count == 0 && @groups.count == 0
          @specific = 0
          return
        end

        @works.each { |w| next if w.part_group; @total += w.total; @extra_t_para += w.extra; @missing_t_para += w.missing; @extra_pushim_t_para += w.extra_pushim}
        @groups.each { |g| @total += g.total; @extra_t_para += g.extra; @missing_t_para += g.missing; @extra_pushim_t_para += g.extra_pushim}
        @extra_t = @extra_t_para
        @extra_pushim_t = @extra_pushim_t_para
        if @user.shkurt_pushim == true
          @missing_t_para -= @i * 10
        end
        @missing_t = @missing_t_para 
        @total = @total - (@extra_t + @extra_pushim_t)
        if @extra_t_para >= @missing_t
          @extra_t = @extra_t_para - @missing_t
        elsif (@extra_pushim_t_para + @extra_t_para) >= @missing_t
          @missing_t -= @extra_t_para
          @extra_t = 0
          @extra_pushim_t = @extra_pushim_t_para - @missing_t
        else
          @extra_t = 0
          @extra_pushim_t = 0
          if @missing_t > @total
            @total = 0
          else
            @total = @total - @missing_t
          end
        end
        @ora = @user.ora
        @ora_e = @user.ora_e
        @ora_p = @user.ora_p
        @salary = (@total * @ora/60) 
        @sales = @user.sales 
        @sig = @salary * 0.05
        @salary_ps = @salary - @sig
        if @user.salary_type == "Primare"
          if @salary_ps>450
            @tatimi = (@salary_ps-450)*0.1+22.8
          elsif @salary_ps>250
            @tatimi = (@salary_ps-250)*0.08+6.8
          elsif @salary_ps>80
            @tatimi = (@salary_ps-80)*0.04
          else
            0
          end
        else
          @tatimi = @salary * 0.1
        end
        @salary_neto = @salary - (@sig + @tatimi)
        @oret_e = @extra_t * @ora_e/60
        @oret_p = @extra_pushim_t * @ora_p/60
        @oret_e_kohe = @extra_t * 1.3
        @oret_p_kohe = @extra_pushim_t * 1.5
        @salary_e = @salary + @oret_e + @oret_p + @sales
        @sig_e = @salary_e * 0.05
        @salary_ps_e = @salary_e - @sig_e
        if @user.salary_type == "Primare"
          if @salary_ps_e>450
            @tatimi_e = (@salary_ps_e-450)*0.1+22.8
          elsif @salary_ps_e>250
            @tatimi_e = (@salary_ps_e-250)*0.08+6.8
          elsif @salary_ps_e>80
            @tatimi_e = (@salary_ps_e-80)*0.04
          else
            0
          end
        else
          @tatimi_e = @salary_e * 0.1
        end
        @sig_e = @salary_e * 0.05
        @salary_ps_e = @salary_e - @sig_e
        @salary_e_n = @salary_e - (@sig_e + @tatimi_e)
        @extra_payment ||= @salary_e_n - @salary_neto
        @specific = true
      else
        params[:search] ||= {}
        @datat = params[:search][:datat] 
        pushim_dates(@datat)
        @date_from = Date.parse(params[:search][:date_from]) rescue ""
        @date_to = Date.parse(params[:search][:date_to]) rescue ""
        users_month(@user, @date_from, @date_to)
        @works.each { |w| next if w.part_group; @total += w.total; @extra_t_para += w.extra; @missing_t_para += w.missing; @extra_pushim_t_para += w.extra_pushim}
        @groups.each { |g| @total += g.total; @extra_t_para += g.extra; @missing_t_para += g.missing; @extra_pushim_t_para += g.extra_pushim}
        @extra_t = @extra_t_para
        @extra_pushim_t = @extra_pushim_t_para
        @missing_t = @missing_t_para
        if @extra_t_para >= @missing_t
          @extra_t = @extra_t_para - @missing_t
        elsif (@extra_pushim_t_para + @extra_t_para) >= @missing_t
          @missing_t -= @extra_t_para
          @extra_t = 0
          @extra_pushim_t = @extra_pushim_t_para - @missing_t
        else
          @extra_t = 0
          @extra_pushim_t = 0
        end
        @salary = @user.salary
        @sales = @user.sales 
        @sig = @salary * 0.05
        @salary_ps = @salary - @sig
        if @user.salary_type == "Primare"
          if @salary_ps>450
            @tatimi = (@salary_ps-450)*0.1+22.8
          elsif @salary_ps>250
            @tatimi = (@salary_ps-250)*0.08+6.8
          elsif @salary_ps>80
            @tatimi = (@salary_ps-80)*0.04
          else
            @tatimi = 0
          end
        else
          @tatimi = @salary * 0.1
        end
        @salary_neto = @salary - (@sig + @tatimi)
        @ora = @user.ora
        @ora_e = @user.ora_e
        @ora_p = @user.ora_p
        @oret_e = @extra_t * @ora_e/60
        @oret_p = @extra_pushim_t * @ora_p/60
        @oret_e_kohe = @extra_t * 1.3
        @oret_p_kohe = @extra_pushim_t * 1.5
        @salary_e = @salary + @oret_e + @oret_p + @sales
        @sig_e = @salary_e * 0.05
        @salary_ps_e = @salary_e - @sig_e
        if @user.salary_type == "Primare"
          if @salary_ps_e>450
            @tatimi_e = (@salary_ps_e-450)*0.1+22.8
          elsif @salary_ps_e>250
            @tatimi_e = (@salary_ps_e-250)*0.08+6.8
          elsif @salary_ps_e>80
            @tatimi_e = (@salary_ps_e-80)*0.04
          else
            @tatimi_e = 0
          end
        else
          @tatimi_e = @salary_e * 0.1
        end
        @salary_e_n = @salary_e - (@sig_e + @tatimi_e)
        @extra_payment ||= @salary_e_n - @salary_neto
        @specific = false
      end
      
    end
    @user.works.build
  end


  def gen_specific_xl
    @date_from = Date.parse(params[:date_from]) rescue ""
    @date_to = Date.parse(params[:date_to]) rescue ""
    @user = User.find(params[:id])
    if @user.works.count != 0 
      @works = @user.works.sort_by { |w| [w.start]}
      @groups = @user.groups.select { |w| w.works.count != 0}.sort_by { |w| [w.works.first.start]}
      @total = 0
      @extra_t_para = 0
      @missing_t = 0
      @missing_t_para = 0
      @extra_pushim_t_para = 0
      @extra_t = 0
      @extra_pushim_t = 0
      @sales = 0
      users_month(@user, @date_from, @date_to)
      @works.each { |w| next if w.part_group; @total += w.total; @extra_t_para += w.extra; @missing_t_para += w.missing; @extra_pushim_t_para += w.extra_pushim}
      @groups.each { |g| @total += g.total; @extra_t_para += g.extra; @missing_t_para += g.missing; @extra_pushim_t_para += g.extra_pushim}
      @extra_t = @extra_t_para
      @extra_pushim_t = @extra_pushim_t_para
      @missing_t = @missing_t_para
      @total = @total - (@extra_t + @extra_pushim_t)
      if @extra_t_para >= @missing_t
        @extra_t = @extra_t_para - @missing_t
      elsif (@extra_pushim_t_para + @extra_t_para) >= @missing_t
        @missing_t -= @extra_t_para
        @extra_t = 0
        @extra_pushim_t = @extra_pushim_t_para - @missing_t
      else
        @extra_t = 0
        @extra_pushim_t = 0
        if @missing_t > @total
          @total = 0
        else
          @total = @total - @missing_t
        end
      end
      @ora = @user.ora
      @ora_e = @user.ora_e
      @ora_p = @user.ora_p
      @salary = (@total * @ora/60) 
      @sales = @user.sales 
      @sig = @salary * 0.05
      @salary_ps = @salary - @sig
      if @user.salary_type == "Primare"
        if @salary_ps>450
          @tatimi = (@salary_ps-450)*0.1+22.8
        elsif @salary_ps>250
          @tatimi = (@salary_ps-250)*0.08+6.8
        elsif @salary_ps>80
          @tatimi = (@salary_ps-80)*0.04
        else
          @tatimi = 0
        end
      else
        @tatimi = @salary * 0.1
      end
      @salary_neto = @salary - (@sig + @tatimi)
      @oret_e = @extra_t * @ora_e/60
      @oret_p = @extra_pushim_t * @ora_p/60
      @oret_e_kohe = @extra_t * 1.3
      @oret_p_kohe = @extra_pushim_t * 1.5
      @salary_e = @salary + @oret_e + @oret_p + @sales
      @sig_e = @salary_e * 0.05
      @salary_ps_e = @salary_e - @sig_e
      if @user.salary_type == "Primare"
        if @salary_ps_e>450
          @tatimi_e = (@salary_ps_e-450)*0.1+22.8
        elsif @salary_ps_e>250
          @tatimi_e = (@salary_ps_e-250)*0.08+6.8
        elsif @salary_ps_e>80
          @tatimi_e = (@salary_ps_e-80)*0.04
        else
          @tatimi_e = 0
        end
      else
        @tatimi_e = @salary_e * 0.1
      end
      @sig_e = @salary_e * 0.05 
      @salary_ps_e = @salary_e - @sig_e
      @salary_e_n = @salary_e - (@sig_e + @tatimi_e)
      @extra_payment ||= @salary_e_n - @salary_neto
      @specific = true
    end
    render xlsx: "Pagesa mujore per #{@user.name} per periudhen: #{@date_from} - #{@date_to}", template: "users/show.xlsx.axlsx" 
  end

  def gen_xl
    @date_from = Date.parse(params[:date_from]) rescue ""
    @date_to = Date.parse(params[:date_to]) rescue ""
    @user = User.find(params[:id])
    if @user.works.count != 0 
      @works = @user.works.sort_by { |w| [w.start]}
      @groups = @user.groups.select { |w| w.works.count != 0}.sort_by { |w| [w.works.first.start]}
      @total = 0
      @extra_t_para = 0
      @missing_t = 0
      @missing_t_para = 0
      @extra_pushim_t_para = 0
      @extra_t = 0
      @extra_pushim_t = 0
      @sales = 0
      users_month(@user, @date_from, @date_to)
      @works.each { |w| next if w.part_group; @total += w.total; @extra_t_para += w.extra; @missing_t_para += w.missing; @extra_pushim_t_para += w.extra_pushim}
      @groups.each { |g| @total += g.total; @extra_t_para += g.extra; @missing_t_para += g.missing; @extra_pushim_t_para += g.extra_pushim}
      @extra_t = @extra_t_para
      @extra_pushim_t = @extra_pushim_t_para
      @missing_t = @missing_t_para
      if @extra_t_para >= @missing_t
        @extra_t = @extra_t_para - @missing_t
      elsif (@extra_pushim_t_para + @extra_t_para) >= @missing_t
        @missing_t -= @extra_t_para
        @extra_t = 0
        @extra_pushim_t = @extra_pushim_t_para - @missing_t
      else
        @extra_t = 0
        @extra_pushim_t = 0
      end
      @salary = @user.salary
      @sales = @user.sales 
      @sig = @salary * 0.05
      @salary_ps = @salary - @sig
      if @user.salary_type == "Primare"
        if @salary_ps>450
          @tatimi = (@salary_ps-450)*0.1+22.8
        elsif @salary_ps>250
          @tatimi = (@salary_ps-250)*0.08+6.8
        elsif @salary_ps>80
          @tatimi = (@salary_ps-80)*0.04
        else
          0
        end
      else
        @tatimi = @salary * 0.1
      end
      @salary_neto = @salary - (@sig + @tatimi)
      @ora = @user.ora
      @ora_e = @user.ora_e
      @ora_p = @user.ora_p
      @oret_e = @extra_t * @ora_e/60
      @oret_p = @extra_pushim_t * @ora_p/60
      @oret_e_kohe = @extra_t * 1.3
      @oret_p_kohe = @extra_pushim_t * 1.5
      @salary_e = @salary + @oret_e + @oret_p + @sales
      @sig_e = @salary_e * 0.05
      @salary_ps_e = @salary_e - @sig_e
      if @user.salary_type == "Primare"
        if @salary_ps_e>450
          @tatimi_e = (@salary_ps_e-450)*0.1+22.8
        elsif @salary_ps_e>250
          @tatimi_e = (@salary_ps_e-250)*0.08+6.8
        elsif @salary_ps_e>80
          @tatimi_e = (@salary_ps_e-80)*0.04
        else
          0
        end
      else
        @tatimi_e = @salary_e * 0.1
      end
      @salary_e_n = @salary_e - (@sig_e + @tatimi_e)
      @extra_payment ||= @salary_e_n - @salary_neto
    end
    # redirect_to @user
    # PagasMailer.with(user: @user, date_from: @date_from, date_to: @date_to).new_paga_email.deliver_now
    render xlsx: "Pagesa mujore per #{@user.name} per periudhen: #{@date_from} - #{@date_to}", template: "users/show.xlsx.axlsx" 
  end

  def send_email
    @date_from = params[:date_from] rescue ""
    @date_to = params[:date_to] rescue ""
    @user = User.find(params[:id])
    PagasMailer.with(user: @user, date_from: @date_from, date_to: @date_to, current_admin: @current_admin).paga_email.deliver_now
    redirect_to @user
  end

  def specific_contract
    @user = User.find(params[:id])
    if @user.spec_contract == true
      @user.spec_contract = false
      @user.save
      redirect_to edit_user_path @user
    else
      @user.spec_contract = true
      @user.save
      redirect_to spec_cont_path @user
    end
  end

  def specific_contract_days
    @user = User.find(params[:id])
    @specific_contract = @user.specific_contract
  end

  def send_specific_email
    @date_from = params[:date_from] rescue ""
    @date_to = params[:date_to] rescue ""
    @user = User.find(params[:id])
    PagasMailer.with(user: @user, date_from: @date_from, date_to: @date_to, current_admin: @current_admin).paga_specific_email.deliver_now
    redirect_to @user
  end

  def update 
    @user = User.find(params[:id])
    
    if params[:add_work]
      @user.update_attributes(user_params)
      pushim_dates = Pushim.all
      @work = @user.works.last
      
      case @work.start.strftime("%A")
      when "Monday"
        @work.pushim = true if @user.pushimet[0]
        @work.save
      when "Tuesday"
        @work.pushim = true if @user.pushimet[1]
        @work.save
      when "Wednesday"
        @work.pushim = true if @user.pushimet[2]
        @work.save
      when "Thursday"
        @work.pushim = true if @user.pushimet[3]
        @work.save
      when "Friday"
        @work.pushim = true if @user.pushimet[4]
        @work.save
      when "Saturday"
        @work.pushim = true if @user.pushimet[5]
        @work.save
      when "Sunday"
        @work.pushim = true if @user.pushimet[6]
        @work.save
      else
        @work.pushim = false
      end
      if pushim_dates.any? { |p| p.date == @work.start.to_date}
        @work.pushim = true
        @work.save
      end
      group_work(@work)
      Log.create(admin: @current_admin, text: "U shtua dite e punes per perdoruesin #{@user.name}(#{@user.idnum})")  
      redirect_to @user  
      return
    end              
         
    
    if @user.update_attributes(user_params)
      redirect_to @user                  

      Log.create(admin: @current_admin, text: "U ndryshua perdoruesi #{@user.name}(#{@user.idnum})")                                                                                      
    else
      @errors = []
      if @user.errors.any?
        @user.errors.full_messages.each do |msg|
          @errors.push msg
        end
      end
      redirect_to edit_user_path(@user, errors: @errors)
    end
  end

  private

    def user_params 
      params.require(:user).permit(:name, :idnum, :contract, :comment, :pushimi_vjetor, :pushimi_mjekesor, :email, :salary, :shkurt_pushim, :sales, :salary_type, pushimet:[], works_attributes: [ :id, :start, :end, :_destroy])
    end
end
