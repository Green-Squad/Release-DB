module Approvable
  extend ActiveSupport::Concern

  included do
    has_paper_trail meta: { status: :set_status },
                    on: [:update, :destroy]
  end

  def rollback
    model = self.class.name
    PaperTrail::Version.where(item_type: model, status: "approved", item_id: id).order(:created_at).last.reify.save
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