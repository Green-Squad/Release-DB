# config/initializers/paper_trail.rb

# the following line is required for PaperTrail >= 4.0.0 with Rails
#PaperTrail::Rails::Engine.eager_load!

module PaperTrail
  class Version < ActiveRecord::Base
    attr_accessible :status
  end
end