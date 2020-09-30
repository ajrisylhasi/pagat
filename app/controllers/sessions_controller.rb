class SessionsController < ApplicationController
	skip_before_action :go_login
  def new
  end

  def new_user
  end

  def create
    if params[:admin]
    	admin = Admin.find_by(name: params[:session][:name])
      if !admin
        flash[:danger] = 'Perdoruesi nuk ekziston.'
        redirect_to login_path
      elsif !(admin.authenticate(params[:session][:password]))
        flash[:danger] = 'Te dhenat nuk jane te sakta'
        redirect_to login_path
      elsif admin.authenticate(params[:session][:password])
        log_in(admin)
        redirect_to root_path
      else
        flash[:danger] = "Diqka eshte Gabim"
        redirect_to login_path
      end
    elsif params[:user]
      user = User.find_by(name: params[:session][:name])
      if !user
        flash[:danger] = 'Perdoruesi nuk ekziston.'
        redirect_to login_user_path
      elsif !(user.idnum == params[:session][:idnum])
        flash[:danger] = 'Te dhenat nuk jane te sakta'
        redirect_to login_user_path
      elsif user.idnum == params[:session][:idnum]
        log_in_user(user)
        redirect_to kerkesa_path
        return
      end
    else
      flash[:danger] = "Sjom ka di shka o ka bohet."
      redirect_to login_path
    end
  end
end