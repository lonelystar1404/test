class SessionsController < ApplicationController
 	skip_before_action :ensure_login, only: [:new, :create]

  def new
  	#Login page - new.html.erb
  end

  def create
  	user = User.find_by(email: params[:user][:email])
  	password = params[:user][:password]

  	if user && user.authenticate(password)
     
  		session[:user_id] = user.id
      flash[:success] = 'Login successful'
      redirect_to root_path
 

  		# redirect_to root_path, notice: "Logged in successfully"
  	else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
  		# redirect_to login_path, alert: "Invalid email/passowrd combination"
  	end
  end

  def destroy
  	reset_session #wipe the session clean
    flash[:success] = 'You have successfully logged out.'
    redirect_to login_path
  	# redirect_to login_path, notice: "You have been logged out"
  end
end
