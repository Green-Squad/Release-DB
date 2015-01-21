class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string :name
      t.string :slug
      t.references :category, index: true

      t.timestamps
    end
  end
end
