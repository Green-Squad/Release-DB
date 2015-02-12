class RegionsController < ApplicationController
  before_action :set_region, only: [:show, :edit, :update, :destroy]

  # GET /regions
  # GET /regions.json
  def index
    # Rails.cache.delete('region_list')
    @regions = Rails.cache.fetch("region_list", :expires_in => 1.week) do
      global = Region.find_by_name("Global")
      united_states = Region.find_by_name("United States")
      other_regions = Region.where("name != ? AND name != ?", "United States", "Global").order(:name)
      
      regions_array = []
      regions_array << global << united_states
      other_regions.each do |region|
        regions_array << region
      end
      regions_array
    end

    
  end

  # GET /regions/1
  # GET /regions/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_region
      @region = Region.find(params[:id])
    end
end
