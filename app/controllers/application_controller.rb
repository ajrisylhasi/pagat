class ApplicationController < ActionController::Base
	include ApplicationHelper
	
	before_action :go_login
end
