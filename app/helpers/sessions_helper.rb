module SessionsHelper
	def log_in(admin)
    session[:admin_id] = admin.id
  end

  def current_admin
    @current_admin ||= Admin.find_by(id: session[:admin_id])
  end

  def logged_in?
    !current_admin.nil?
  end

  def log_in_user(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in_user?
    current_admin
    !current_user.nil?
  end

  def log_out_user
    session.delete(:user_id)
    @current_user = nil
    redirect_to login_user_path
  end

  def log_out
    session.delete(:admin_id)
    @current_admin = nil
    redirect_to login_path
  end
  
  def go_login
    unless logged_in?
      flash[:danger] = "Duhet te kyqeni paraprakisht."
      redirect_to login_path
    end
  end

  def go_login_user
    unless logged_in_user?
      flash[:danger] = "Duhet te kyqeni si punemarres paraprakisht."
      redirect_to login_user_path
    end
  end
  
end
