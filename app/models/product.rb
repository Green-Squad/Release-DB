class Product < ActiveRecord::Base
  belongs_to :category
  has_many :releases
  has_many :launch_dates, through: :releases
  has_many :regions, through: :releases
  has_many :mediums, through: :releases
  
  validates :name, presence: true
  validates :category_id, presence: true
  #validates :slug, presence: true, uniqueness: { case_sensitive: false }
end