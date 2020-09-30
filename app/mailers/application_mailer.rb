class ApplicationMailer < ActionMailer::Base
	include ApplicationHelper
	include SessionsHelper
	  default from: 'Albina Dyla Company <humanresources@albinadyla.com>'
	  layout 'mailer'
end
