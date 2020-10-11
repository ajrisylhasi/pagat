class PushimesController < ApplicationController
	skip_before_action :go_login, except: [:kerkesas, :kerkesa_destroy, :finish_kerkesa]
	before_action :go_login_user, except: [:kerkesas, :kerkesa_destroy, :finish_kerkesa]

	def kerkesa
		@kerkesa ||= Kerkesa.new
	end	

	def show
	end

	def kerkesa_destroy
		@kerkesa = Kerkesa.find(params[:id])
		PagasMailer.with(user: @kerkesa.user, kerkesa: @kerkesa, admin: @current_admin).pushim_destroy.deliver_now
		@kerkesa.destroy
		redirect_to kerkesas_path
	end

	def kerkesa_update
		@kerkesa = Kerkesa.find(params[:id])

		if params[:kerkesa].nil?
			flash[:danger] = "Nuk mund te uploadohet file"
			redirect_to show_path
			return
		end
		@kerkesa.file = params[:kerkesa][:file]
		if @kerkesa.save
			redirect_to show_path
		else
			flash[:danger] = "Nuk mund te uploadohet file"
			redirect_to show_path
		end
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
		if start > Date.new(Date.today.year, 6,30) && data[:lloji_pushimit] == "Pushim Vjetor" && @kerkesa.numri_diteve > @current_user.pushimi_vjetor_sivjet
			flash[:danger] = "Nuk keni dite te mjatueshme"
			redirect_to show_path
		elsif start > Date.new(Date.today.year, 6,30) && data[:lloji_pushimit] == "Pushim Mjekesor" && @kerkesa.numri_diteve > @current_user.pushimi_mjekesor_sivjet
			flash[:danger] = "Nuk keni dite te mjatueshme"
			redirect_to show_path
		elsif data[:lloji_pushimit] == "Pushim Vjetor" && @kerkesa.numri_diteve > @current_user.pushimi_vjetor
			flash[:danger] = "Nuk keni dite te mjatueshme"
			redirect_to show_path
		elsif data[:lloji_pushimit] == "Pushim Mjekesor" && @kerkesa.numri_diteve > @current_user.pushimi_mjekesor
			flash[:danger] = "Nuk keni dite te mjatueshme"
			redirect_to show_path
		elsif @kerkesa.save
			flash[:success] = "Kerkesa u dergua me sukses"
			PagasMailer.with(user: @current_user, kerkesa: @kerkesa).pushim_email.deliver_now
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
		start = @kerkesa.data_fillimit
		endi = @kerkesa.data_mbarimit
		no_work = []
		i = 1
		@kerkesa.user.pushimet.each do |p|
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
		if @kerkesa.lloji_pushimit == "Pushim Vjetor" && @kerkesa.numri_diteve > @kerkesa.user.pushimi_vjetor
			flash[:danger] = "Nuk keni dite te mjatueshme"
			redirect_to kerkesas_path
		elsif @kerkesa.lloji_pushimit == "Pushim Mjekesor" && @kerkesa.numri_diteve > @kerkesa.user.pushimi_mjekesor
			flash[:danger] = "Nuk keni dite te mjatueshme"
			redirect_to kerkesas_path
		else
			@kerkesa.finished = true
			@kerkesa.save
			PagasMailer.with(user: @kerkesa.user, kerkesa: @kerkesa, admin: @current_admin).pushim_confirm.deliver_now
			redirect_to kerkesas_path
		end
	end

	def delete_image_attachment
      @file = ActiveStorage::Attachment.find(params[:format])
      @file.purge
      redirect_back(fallback_location: request.referer)
    end
end
