class ApprovalsController < ApplicationController
  def index
    pending_products = PaperTrail::Version.where(item_type: "Product", status: "pending").order(:created_at)
    pending_releases = PaperTrail::Version.where(item_type: "Release", status: "pending").order(:created_at)
    
    @pending_models = {"Product" => pending_products, "Release" => pending_releases}
  end
  
  def approve
    version = PaperTrail::Version.find_by_id(params[:id])
    if version
      model = version.item_type.constantize
      model.paper_trail_off!
      version.reify.save
      model.paper_trail_on!
      version.update_attributes(status: "approved")
      flash[:success] = "Version #{params[:id]} has been approved"
    else
      flash[:error] = "Version #{params[:id]} does not exist or has already been rejected"
    end
    redirect_to approvals_url
  end
  
  def reject
    version = PaperTrail::Version.find(params[:id])
    if (version.status == "approved")
      flash[:error] = "Version #{params[:id]} has already been approved"
    else
      version.destroy
      flash[:info] = "Version #{params[:id]} has been rejected"
    end
    redirect_to approvals_url
  end
end
