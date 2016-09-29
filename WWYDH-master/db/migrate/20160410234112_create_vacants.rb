class CreateVacants < ActiveRecord::Migration
  def change
    create_table :vacants do |t|
      t.string :full_address
      t.string :block
      t.string :lot
      t.string :zip_code
      t.string :city
      t.string :neighborhood
      t.string :police_district
      t.integer :council_district
      t.decimal :longitude
      t.decimal :latitude
      t.string :owner
      t.string :use
      t.string :mailing_address
    end
  end
end
