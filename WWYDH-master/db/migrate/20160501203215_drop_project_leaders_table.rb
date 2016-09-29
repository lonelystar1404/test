class DropProjectLeadersTable < ActiveRecord::Migration
  def change
    drop_table :project_leaders, force: :cascade
  end
end
