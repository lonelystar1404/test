class ProjectLeadersController < ApplicationController

  def new
    @project = Project.find(params[:project_id])
		@project_leader = ProjectLeader.new
	end

	def create
    # @project_leader = ProjectLeader.new(project_leader_params)
    @project = Project.find(params[:project_id])
    @project_leader = ProjectLeader.create
    @project.project_leader = @project_leader
    @project_leader.user = current_user

		if @project_leader.save
			flash[:success] = "You are the new project leader!"
			redirect_to @project
		else
			render 'new'
		end
	end

  def project_leader_params
		params.require(:project_leader).permit(:user_id, :project_id)
	end

end
