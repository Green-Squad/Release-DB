class Product < ActiveRecord::Base
  belongs_to :category
  has_many :releases
  has_many :launch_dates, through: :releases
  has_many :regions, through: :releases
  has_many :mediums, through: :releases
end