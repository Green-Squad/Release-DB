class Region < ActiveRecord::Base
  has_many :releases

  validates :name, presence: true
  validates :slug, uniqueness: { case_sensitive: false }
  
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]
  
  def slug_candidates
    [
      :name,
      [:name, :id]
    ]
  end
end
