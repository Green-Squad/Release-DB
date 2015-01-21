class Release < ActiveRecord::Base
  belongs_to :product
  belongs_to :launch_date
  belongs_to :medium
  belongs_to :region
end
