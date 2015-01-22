module Sluggable
  extend ActiveSupport::Concern

  included do
    after_create :fix_slug
  end

  private

  def fix_slug
    self.slug = nil
    self.save!
  end
end