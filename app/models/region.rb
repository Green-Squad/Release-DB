class Region < ActiveRecord::Base
  has_many :releases

  validates :name, presence: true
  #validates :slug, presence: true, uniqueness: { case_sensitive: false }
end
