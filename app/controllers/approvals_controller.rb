class ApprovalsController < ApplicationController
  def index
    @pending_products = PaperTrail::Version.where(item_type: "Product", status: "pending")
    @pending_releases = PaperTrail::Version.where(item_type: "Release", status: "pending")
  end
end
