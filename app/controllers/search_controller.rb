class SearchController < ApplicationController
  require 'open-uri'

  def search
    if params[:search]
      search = params[:search].downcase.delete(' ')
      product = Product.where("LOWER(REPLACE(name, ' ', '')) LIKE ?", "#{search}%").order(:name).first
      if product
        redirect_to product_url(product)
      else
        begin
          @google_request = JSON.load(open(ENV['SEARCH_URL'] + params[:search]));
          @total_results = @google_request["queries"]["request"][0]["totalResults"].to_i
          render "index"
        rescue
          redirect_to "https://www.google.com/?#q=site:dev.release.kyledornblaser.com+#{params[:search]}"
        end
      end
    else
      redirect_to root_url
    end
  end

  def autocomplete
    name = params[:id].downcase.delete(' ').delete('/')
    @products = Product.where("LOWER(REPLACE(name, ' ', '')) LIKE ?", "%#{name}%").order(:name).take(10)
    @products_array = []
    @products.each do |product|
      @products_array.push(product.name)
    end
    respond_to do |format|
      format.json { render json: @products_array }
    end
  end
end
