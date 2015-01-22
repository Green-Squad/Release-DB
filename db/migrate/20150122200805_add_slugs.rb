class AddSlugs < ActiveRecord::Migration
  def change
    add_index :media, :slug, unique: true
    add_index :launch_dates, :slug, unique: true
    add_index :products, :slug, unique: true
    add_index :categories, :slug, unique: true
    add_index :regions, :slug, unique: true
  end
end
