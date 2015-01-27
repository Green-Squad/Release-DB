class CreateReleases < ActiveRecord::Migration
  def change
    create_table :releases do |t|
      t.references :product, index: true
      t.references :launch_date, index: true
      t.references :medium, index: true
      t.references :region, index: true
      t.text :source

      t.timestamps
    end
  end
end
