class Category < ActiveRecord::Base
  #attr_accessible :name, :slug
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

  # returns a string like "Movies, Books, and TV"
  def self.sentence
    categories = all
    category_array = []
    categories.each do |category|
      category_array << category.name
    end
    category_array.to_sentence
  end
end