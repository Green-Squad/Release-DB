class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  
  # GET /products
  # GET /products.json
  def index
    @products = Product.all.order(:name).page params[:page]
  end

  # GET /products/1
  # GET /products/1.json
  def show
    #@releases = Release.joins(:launch_date, :product).where("product_id = ?", @product.id).order("launch_dates.launch_date DESC")
    
    @releases = @product.releases
    @releases = @releases.to_a
    @releases.sort! { |a,b| b.launch_date.date <=> a.launch_date.date }
  end

  # POST /products
  # POST /products.json
  def create
    Product.paper_trail_off!
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.json { render :show, status: :created, location: @product }
        handle_creation @product 
      else
        format.json { render json: @product.errors, status: :bad_request }
      end
    end
    Product.paper_trail_on!
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    Product.paper_trail_off!
    respond_to do |format|
      if strong_xedit_params(params[:name]) && @product.update_attributes(params[:name] => params[:value])
        format.json { render :show, status: :ok, location: @product }
        rollback @product
      else
        format.json { render json: @product.errors, status: :bad_request}
      end
    end
    Product.paper_trail_on!
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def product_params
    params.permit(:name, :category_id)
  end

  def strong_xedit_params(col_name)
    allowed_names = ['name', 'category_id']
    allowed_names.include? col_name
  end
end
