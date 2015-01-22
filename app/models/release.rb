class Release < ActiveRecord::Base
  belongs_to :product
  belongs_to :launch_date
  belongs_to :medium
  belongs_to :region

  validates :product_id, presence: true
  validates :launch_date_id, presence: true
  validates :medium_id, presence: true
  validates :region_id, presence: true
  #validates :slug, presence: true, uniqueness: { case_sensitive: false }
  
end
