class Medium < ActiveRecord::Base
  belongs_to :category
  has_many :releases
  
  validates :name, presence: true
  validates :category_id, presence: true
  #validates :slug, presence: true, uniqueness: { case_sensitive: false }
end
