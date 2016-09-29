class VacantsController < ApplicationController

	skip_before_action :ensure_login, only: [:index, :show]

	respond_to :js

	def index
		@remote_flag = false

		@vacants = Vacant.search(params).order("id ASC")
										 .paginate(page: params[:page], per_page: 10)
  end

	def show
		@vacant = Vacant.find(params[:id])

		@projects = Project.search(vacant_id: @vacant.id)
	end

	def new
		@vacant = Vacant.new
	end

	def create
		@vacant = Vacant.new(vacant_params)
		if @vacant.save
			flash[:success] = "Created new location!"
			redirect_to @vacant
		else
			render 'new'
		end
	end

	def vacant_params
		params.require(:vacant).permit(:full_address, :block, :lot, :zip_code,
																	 :city, :neighborhood, :police_district,
																	 :council_district, :longitude, :latitude,
																	 :owner, :use, :mailing_address)
	end

end
