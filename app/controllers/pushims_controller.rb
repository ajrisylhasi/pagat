class PushimsController < ApplicationController

	def destroy
		@pushim = Pushim.find(params[:id])
	    @pushim.destroy
	    redirect_to pushimet_path
	    Log.create(admin: @current_admin, text: "U fshi pushimi zyrtar i dates: #{@pushim.date}")
	end

end
