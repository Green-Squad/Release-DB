class ApprovalsController < ApplicationController
  before_action :authenticate_admin_user!, except: :feed
  
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
    redirect_to admin_dashboard_url
  end

  def reject
    version = PaperTrail::Version.find(params[:id])
    if (version.status == "approved")
      flash[:error] = "Version #{params[:id]} has already been approved"
    else
      version.destroy
      flash[:info] = "Version #{params[:id]} has been rejected"
    end
    redirect_to admin_dashboard_url
  end
  
  def feed
    @pending_approvals = PaperTrail::Version.where("(item_type = ? OR item_type = ?) AND status = 'pending'", 'Product', 'Release').order(:created_at)
    respond_to do |format|
      format.rss { render :layout => false }
    end
  end
end
