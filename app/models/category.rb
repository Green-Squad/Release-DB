class Category < ActiveRecord::Base
  include Sluggable
  
  has_many :products
  has_many :media
  
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