class DeklarimsController < ApplicationController
	def index
		@i = 0
		params[:page] ||= (Deklarim.all.count/10.0).ceil
		if params[:page] == 0 
			params[:page] = 1
		end
		@deklarims = Deklarim.all.paginate(:page => params[:page], :per_page=>10)
		@new_deklarim = Deklarim.new
	end

	def create
		@deklarim = Deklarim.new deklarim_params
		if @deklarim.save
			flash[:success] = "Deklarimi u krijua"
			redirect_to deklarims_path
		else
			flash[:danger] = "Deklarimi nuk eshte krijuar"
			redirect_to deklarims_path
		end
	end

	def update
		@deklarim = Deklarim.find(params[:id])
		if @deklarim.update_attributes(deklarim_params)
			flash[:info] = "Deklarimi u ndryshua"
			redirect_to deklarims_path
		else
			flash[:danger] = "Deklarimi u ndryshua"
			redirect_to deklarims_path
		end
	end

	def edit
		@deklarim = Deklarim.find(params[:id])
	end

	def show
		@i = 0
		@deklarim = Deklarim.find(params[:id])
		@pagas = @deklarim.pagas
		respond_to do |format|
			format.html
			format.json
			format.pdf { render pdf: "Deklarimi-#{@deklarim.muaji}", orientation: 'Portrait' }
			format.xlsx 
		end	
	end

	def show_xl
		@i = 0
		@deklarim = Deklarim.find(params[:id])
		@pagas = @deklarim.pagas
		render xlsx: "Deklarimi per muajin #{@deklarim.muaji}", template: "deklarims/show.xlsx.axlsx" 
		return
	end

	private

	def deklarim_params
		params.require(:deklarim).permit(:muaji)
	end
end