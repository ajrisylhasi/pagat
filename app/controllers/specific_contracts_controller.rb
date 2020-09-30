class SpecificContractsController < ApplicationController
  def update
  	@specific_contract = SpecificContract.find(params[:id])
  	@user = @specific_contract.user
  	if @specific_contract.update_attributes(att)

      redirect_to spec_cont_path(@user)                   

      Log.create(admin: @current_admin, text: "U ndryshua kontrata per perdoruesin #{@user.name}(#{@user.idnum})")
    else
    	redirect_to spec_cont_path(@user)
    end

  end

  private

    def att 
      params.require(:specific_contract).permit(:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday)
    end
end
