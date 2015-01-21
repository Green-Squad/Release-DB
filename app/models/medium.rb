class Medium < ActiveRecord::Base
  belongs_to :category
  has_many :releases
end
