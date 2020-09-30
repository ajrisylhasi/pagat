class PushimesController < ApplicationController
	skip_before_action :go_login, except: [:kerkesas]
	before_action :go_login_user

	def kerkesa
		@kerkesa ||= Kerkesa.new
	end	

	def show
	end

	def kerkesa_create
		k = params[:kerkesa]
		data = params.require(:kerkesa).permit(:data_punes, :lloji_pushimit, :data_fillimit, :data_mbarimit, :numri_diteve, :file)
		data[:user] = @current_user
		@kerkesa = Kerkesa.new(data)
		if @kerkesa.save
			flash[:success] = "Kerkesa u dergua me sukses"
			redirect_to show_path
		else
			render "kerkesa"
		end
	end

	def kerkesas
		@kerkesas = Kerkesa.all
	end

	def finish_kerkesa
		@kerkesa = Kerkesa.find(params[:id])
		@kerkesa.finished = true
		@kerkesa.save
		redirect_to kerkesas_path
	end

	def delete_image_attachment
      @file = ActiveStorage::Attachment.find(params[:format])
      @file.purge
      redirect_back(fallback_location: request.referer)
    end
end
