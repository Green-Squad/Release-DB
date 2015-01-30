class ReleasesController < ApplicationController
  before_action :set_release, only: [:show, :edit, :update, :destroy]

  # GET /releases
  # GET /releases.json
  def index
    @releases = Release.all
  end

  # GET /releases/1
  # GET /releases/1.json
  def show
  end

  # POST /releases
  # POST /releases.json
  def create
    Release.paper_trail_off!
    launch_date = LaunchDate.where(launch_date: params[:launch_date]).first_or_create
    params[:launch_date_id] = launch_date.id
    @release = Release.new(release_params)

    respond_to do |format|
      if @release.save
        #format.html { redirect_to @release, notice: 'Release was successfully created.' }
        format.json { render :show, status: :created, location: @release }
        handle_creation @release
      else
        #format.html { render :new }
        format.json { render json: @release.errors, status: :unprocessable_entity }
      end
    end
    Release.paper_trail_on!
  end

  # PATCH/PUT /releases/1
  # PATCH/PUT /releases/1.json
  def update
    Release.paper_trail_off!
    if strong_xedit_params(params[:name]) && params[:name] == 'launch_date_id'
      params[:value] = LaunchDate.where(launch_date: params[:value]).first_or_create.id
    end
    
    respond_to do |format|
      if strong_xedit_params(params[:name]) && @release.update_attributes(params[:name] => params[:value])
        format.json { render :show, status: :ok, location: @release }
        rollback @release
      else
        format.json { render json: @release.errors, status: :bad_request}
      end
    end
    Release.paper_trail_on!
  end

  # DELETE /releases/1
  # DELETE /releases/1.json
  def destroy
    @release.destroy
    respond_to do |format|
      format.html { redirect_to releases_url, notice: 'Release was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_release
    @release = Release.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def release_params
    params.permit(:region_id, :launch_date_id, :medium_id, :product_id, :source)
  end

  def strong_xedit_params(col_name)
    allowed_names = ['region_id', 'launch_date_id', 'medium_id', 'source']
    allowed_names.include? col_name
  end
end
