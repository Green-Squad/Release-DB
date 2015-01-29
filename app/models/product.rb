class Product < ActiveRecord::Base
  include Sluggable

  has_paper_trail meta: { status: :set_status },
                  on: [:update, :destroy]
  belongs_to :category
  has_many :releases
  has_many :launch_dates, through: :releases
  has_many :regions, through: :releases
  has_many :mediums, through: :releases

  validates :name, presence: true
  validates :category, presence: true
  validates :slug, uniqueness: { case_sensitive: false }

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]
  def slug_candidates
    [
      :name,
      [:name, self.category.name],
      [:name, self.category.name, :id]
    ]
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def rollback
    previous_version.save
  end

  def destroy_create
    destroy
  end

  # saves after state of model that admin creates and updates the version attributes to approved
  def save_after_state
    update_attributes(updated_at: Time.now)
    versions.last.update_attributes(status: "approved")
  end

  def set_status(status = "pending")
    status
  end
end