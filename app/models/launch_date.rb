class LaunchDate < ActiveRecord::Base
  has_many :releases

  validates :launch_date, presence: true, uniqueness: { case_sensitive: false }
  #validates :slug, presence: true, uniqueness: { case_sensitive: false }
  
  def to_s
    launch_date
  end
end
