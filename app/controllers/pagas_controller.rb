class PagasController < ApplicationController
	def create
		@date_from = Date.parse(params[:date_from]) rescue ""
		@date_to = Date.parse(params[:date_to]) rescue ""
		@user = User.find(params[:id])
		@paga = Paga.new(user: @user)
	end
end