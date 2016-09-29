class UserMailer < ActionMailer::Base
		default :from => "lonelystar1404@gmail.com"

		def registration_confirmation(user)
			@user = user
			mail(:to => "#{user.username} <#{user.email}>", :subject => "Please confirm your registration")
		end
	end
