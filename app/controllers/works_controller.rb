class WorksController < ApplicationController
  protect_from_forgery except: :edit
  def index
  	
  end

  def destroy
  	@work = Work.find(params[:id])
  	user = @work.user
  	@work.delete
    Log.create(admin: @current_admin, text: "U ndryshuan ditet e punes per punemarresin #{user.name}(#{user.idnum})")
  	redirect_to user
  end

  def show
  	redirect_to works_path
  end

  def edit
    @work = Work.find(params[:id])
  end

  def update
    @work = Work.find(params[:id])
    if @work.update_attributes(works_params)
      redirect_to @work.user
    else
      redirect_to @work.user
    end
  end

  def import
  	file = params[:file]
  	import_it(file) 
	  redirect_to users_path
  end

  def import_online
    file = params[:file]
    import_it_online(file) 
    redirect_to users_path
  end

  def pushimize
    @work = Work.find(params[:id])
    if @work.pushim == false
      @work.pushim = true

    else
      @work.pushim = false
    end
    @work.save

    Log.create(admin: @current_admin, text: "U ndryshuan ditet e pushimit per punemarresin #{@work.user.name}(#{@work.user.idnum})")
    redirect_to @work.user
  end

  private 

    def works_params
      params.require(:work).permit(:start, :end, :miss)
    end
end
