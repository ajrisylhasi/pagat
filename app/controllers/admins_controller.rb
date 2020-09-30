class AdminsController < ApplicationController
	before_action :find_user, only: [:edit, :show, :update, :destroy]

	def new
		@admin = Admin.new
	end


	def index
		@i=0
    params[:page] ||= (Admin.all.count/10.0).ceil
    if params[:page] == 0 
      params[:page] = 1
    end
    @admins  = Admin.paginate(:page => params[:page], :per_page=>10)
    @admin ||= Admin.new
    @errors = params[:errors]
	end

	def edit
	end

  def pushimet
    @i = 0
    params[:page] ||= (Pushim.all.count/5.0).ceil
    if params[:page] == 0 
      params[:page] = 1
    end
    @pushims  = Pushim.paginate(:page => params[:page], :per_page=>5)
    @pushim = Pushim.new
  end

  def pushimet_zyrtare
    @date = Date.parse(params[:date]) rescue ""
    @komenti = params[:komenti] rescue ""
    @pushim = Pushim.new(date: @date, komenti: @komenti)
    if @pushim.save
      Log.create(admin: @current_admin, text: "Pushimi zyrtar i dates: #{@pushim.date} u krijua")
      redirect_to pushimet_path
    else
      @errors = []
      if @admin.errors.any?
        @admin.errors.full_messages.each do |msg|
          @errors.push msg
        end
      end
      redirect_to pushimet_path(errors: @errors)
    end
  end

	def create
    @admin = Admin.new(admin_params)
    if @admin.save
    	Log.create(admin: @current_admin, text: "Admini i ri #{@admin.name} u krijua")
      redirect_to admins_path
    else
      @errors = []
      if @admin.errors.any?
        @admin.errors.full_messages.each do |msg|
          @errors.push msg
        end
      end
      redirect_to admins_path(errors: @errors)
    end
  end

  def destroy
    name = @current_admin.name
    @admin.logs.each { |m| @admin.logs.delete(m)}
  	@admin.destroy
  	redirect_to admins_path
    Log.create(text: "Admini #{@admin.name} u fshi.", kush: name)
  end

  def logs
    @i = 0
    params[:page] ||= (Log.all.count/5.0).ceil
    if params[:page] == 0
      params[:page] = 1
    end
    @logs  = Log.paginate(:page => params[:page], :per_page=>5)
    params[:search] ||= {}
    @date_from = Date.parse(params[:search][:date_from]) rescue ""
    @date_to = Date.parse(params[:search][:date_to]) rescue ""
    unless @date_from == "" || @date_to == ""
    	@logs = @logs.select { |l| l.created_at.to_date <= @date_to && l.created_at >= @date_from } 
    end
  end

  def update
    @admin = Admin.find(params[:id])
    if @admin.update_attributes(admin_params)

      redirect_to admins_path                      

      Log.create(admin: @current_admin, text: "U ndryshua Admini: #{@admin.name}")                                                                                      
    else
      @errors = []
      if @admin.errors.any?
        @admin.errors.full_messages.each do |msg|
          @errors.push msg
        end
      end
      redirect_to edit_admin_path(@admin, errors: @errors)
    end
  end

	private

		def find_user
			@admin = Admin.find(params[:id])
		end

		def admin_params
			params.require(:admin).permit(:name, :email, :sending_mail, :lang, :password, :password_confirmation)
		end

end
