class AddDefaultValueToSupportTicket < ActiveRecord::Migration
  def change
    change_column :support_tickets, :reviewed, :boolean, default: false
  end
end
