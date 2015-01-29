class Release < ActiveRecord::Base
  include Approvable
  belongs_to :product
  belongs_to :launch_date
  belongs_to :medium
  belongs_to :region

  validates :product_id, presence: true
  validates :launch_date_id, presence: true
  validates :medium_id, presence: true
  validates :region_id, presence: true
  validates :source, presence: true

end
