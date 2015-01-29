class ApprovalsController < ApplicationController
  def index
    @pending_products = PaperTrail::Version.where(item_type: "Product", status: "pending")
    @pending_releases = PaperTrail::Version.where(item_type: "Release", status: "pending")
  end
  
  def approve
    version = PaperTrail::Version.find(params[:id])
    model = version.item_type.constantize
    model.paper_trail_off!
    version.reify.save
    model.paper_trail_on!
    version.update_attributes(status: "approved")
  end
  
  def reject
    version = PaperTrail::Version.find(params[:id])
    version.destroy
  end
end
