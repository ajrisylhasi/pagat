class PagasController < ApplicationController
	def create
		@user = User.find(params[:id])
		@paga = Paga.new(user: @user, paga_bruto: params[:kontributi_pension][0], kontributi_pension: params[:kontributi_pension][1])
		@paga.deklarim = Deklarim.last
		if @paga.deklarim.pagas.any? {|p| p.user == @user}
			flash[:danger] = "Paga nuk mund te deklarohet 2 here per te njejtin punemarres"
			redirect_back(fallback_location: request.referer)
			return
		end
		if @paga.save 
			redirect_back(fallback_location: request.referer)
		else
			flash[:danger] = "Paga nuk mund te deklarohet"
			redirect_back(fallback_location: request.referer)
		end
		Log.create(admin: @current_admin, text: "U shtua paga per #{@user.name}(#{@user.idnum}) nga deklarimi: #{@paga.deklarim.muaji}.")
	end

	def destroy
		@paga = Paga.find(params[:id])
		user = @paga.user
		@paga.delete
		Log.create(admin: @current_admin, text: "U fshi paga per #{user.name}(#{user.idnum}) nga deklarimi: #{@paga.deklarim.muaji}.")
		redirect_to @paga.deklarim
	end

	def edit
		@paga = Paga.find(params[:id])
	end

	def update
		@paga = Paga.find(params[:id])
		if @paga.update_attributes(pagas_params)
			redirect_to @paga.deklarim
		else
			redirect_to @paga.deklarim
		end
	end

	private

	def pagas_params
		params.require(:paga).permit(:paga_bruto, :kontributi_pension, :kontributi_sup, :pune_primare, :perfsh_kont, :apli_tat)
	end
end