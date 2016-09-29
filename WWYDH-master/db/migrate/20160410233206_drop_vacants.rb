class DropVacants < ActiveRecord::Migration
  def up
    drop_table :vacants
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
