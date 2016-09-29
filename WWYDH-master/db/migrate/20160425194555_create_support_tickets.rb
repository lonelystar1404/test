class CreateSupportTickets < ActiveRecord::Migration
  def change
    create_table :support_tickets do |t|
      t.string :name
      t.string :email
      t.text :message
      t.boolean :reviewed

      t.timestamps null: false
    end
  end
end
