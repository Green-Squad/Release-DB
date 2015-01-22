class LaunchDate < ActiveRecord::Base
  has_many :releases

  validates :launch_date, presence: true, uniqueness: { case_sensitive: false }
  validates :slug, uniqueness: { case_sensitive: false }
  
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]
  
  def slug_candidates
    [
      :launch_date,
      [:launch_date, :id]
    ]
  end
  
  def to_s
    launch_date
  end
end
