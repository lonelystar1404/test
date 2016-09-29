class SupportTicketsController < ApplicationController

  skip_before_action :ensure_login, only: [:new, :create]

  def new
    @ticket = SupportTicket.new
  end

  def create
    @ticket = SupportTicket.new(support_ticket_params)

    if @ticket.save
  		flash[:success] = "Created new support ticket!"
  		redirect_to root_path
  	else
  		render 'new'
  	end
  end

  private

	def support_ticket_params
		params.require(:support_ticket).permit(:name, :email, :message)
	end

end
