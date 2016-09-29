class AddVacantRefToProjects < ActiveRecord::Migration
  def change
    add_reference :projects, :vacant, index: true, foreign_key: true
  end
end
