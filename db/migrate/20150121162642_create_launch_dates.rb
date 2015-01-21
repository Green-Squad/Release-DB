class CreateLaunchDates < ActiveRecord::Migration
  def change
    create_table :launch_dates do |t|
      t.string :launch_date
      t.string :slug

      t.timestamps
    end
  end
end
