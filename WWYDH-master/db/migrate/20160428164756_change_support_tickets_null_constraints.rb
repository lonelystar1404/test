class ChangeSupportTicketsNullConstraints < ActiveRecord::Migration
  def change
    change_column_null :support_tickets, :name, false
    change_column_null :support_tickets, :email, false
    change_column_null :support_tickets, :message, false
  end
end
