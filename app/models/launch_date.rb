class LaunchDate < ActiveRecord::Base
  has_many :releases
  
  def to_s
    launch_date
  end
end
