class PushimesController < ApplicationController
	skip_before_action :go_login, except: [:kerkesas]
	before_action :go_login_user, except: [:kerkesas]

	def kerkesa
		@kerkesa ||= Kerkesa.new
	end	

	def show
	end

	def kerkesa_create
		k = params[:kerkesa]
		data = params.require(:kerkesa).permit(:lloji_pushimit, :data_fillimit, :data_mbarimit, :file)
		data[:user] = @current_user
		start = Date.parse(data[:data_fillimit])
		endi = Date.parse(data[:data_mbarimit])
		no_work = []
		i = 1
		data[:user].pushimet.each do |p|
			if p == "true"
				if i == 7
					no_work << 0
					next
				end
				no_work << i
			end
			i+=1
		end
		pushim_dates = Pushim.all
		result = (start..endi).to_a.select {|k| !(no_work.include?(k.wday))}
		result = result.select { |k| !(pushim_dates.any? { |p| p.date == k})}
		data[:numri_diteve] = result.count
		@kerkesa = Kerkesa.new(data)

		if data[:lloji_pushimit] == "Pushim Vjetor" && @kerkesa.numri_diteve > @current_user.pushimi_vjetor
			flash[:danger] = "Nuk keni dite te mjatueshme"
			redirect_to show_path
		elsif data[:lloji_pushimit] == "Pushim Mjekesor" && @kerkesa.numri_diteve > @current_user.pushimi_mjekesor
			flash[:danger] = "Nuk keni dite te mjatueshme"
			redirect_to show_path
		elsif @kerkesa.save
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
