class UsersController < ApplicationController

  skip_before_action :ensure_login, only: [:index, :show, :new, :create,
                                           :confirm_email]

  def index
    @remote_flag = false

    @users = User.search(params).order("id ASC")
                 .paginate(page: params[:page], per_page: 10)
  end

  def show
		@user = User.find(params[:id])
	end

  def my_projects
    @user = User.find(params[:id])
    @user_projects = @user.projects
  end

  def add_to_my_projects
    @my_projects = current_user.projects
    @project = Project.find(params[:id])
    if @my_projects.include? @project
      flash[:error] = "You are already a part of this project!"
      redirect_to @project
    else
      @my_projects << @project
      flash[:success] = "You have joined this project!"
      redirect_to @project
    end
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      UserMailer.registration_confirmation(@user).deliver
  		flash[:success] = "Sign up complete. Please check your email!"
  		redirect_to root_path
  	else
  		render 'new'
  	end
  end

  def confirm_email
    user = User.find_by_confirm_token(params[:id])
    if user
     
      flash[:success] = "Welcome to WWYDH! Your accout has been confirmed."
      redirect_to root_url
    else
      flash[:error] = "User does not exist."
      redirect_to root_url
    end
  end

	private

	def user_params
		params.require(:user).permit(:username, :email, :password,
                                 :password_confirmation)
	end

end
