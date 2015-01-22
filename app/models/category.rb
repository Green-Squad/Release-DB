class Category < ActiveRecord::Base
  has_many :products
  has_many :media
  
  validates :name, presence: true
  #validates :slug, presence: true, uniqueness: { case_sensitive: false }
end