class MediaController < ApplicationController
  before_action :set_medium, only: [:show, :edit, :update, :destroy]

  # GET /media
  # GET /media.json
  def index
    @media = Medium.all
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_medium
      @medium = Medium.find(params[:id])
    end
end
