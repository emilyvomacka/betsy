class ProductsController < ApplicationController 
  before_action :find_product, only: [:show, :edit, :update]
  
  def index
    @products = Product.where(active: true)
  end
  
  def main
    @products = Product.where(active: true)
  end
  
  def show; end
  
  def new
    @product = Product.new
  end
  
  def create
    @product = Product.new(product_params)
    # @product.merchant_id = @current_merchant.id
    
    if @product.save
      flash[:status] = :success
      flash[:success] = "Successfully created product #{@product.name}."
      redirect_to product_path(@product)
    else
      flash[:status] = :failure
      flash[:error] = "Unable to create product #{@product.name}."
      render :new, status: :bad_request
    end
  end
  
  def edit; end
  
  def update
    #require login
    #check if user is authorized
    if @product.update(product_params)
      flash[:status] = :success
      flash[:result_text] = "Successfully updated #{@product.name}."
      redirect_to product_path(@product)
      return
    else 
      flash.now[:status] = :failure
      flash.now[:result_text] = "Unable to update #{@product.name}."
      render :edit, status: :not_found
      return
    end
  end
  
  def retire
    @product = Product.find_by(id: params[:id])
    if @product.retire
      # flash[:status] = :success
      # flash[:success] = "Successfully retired product #{@product.name}."
      redirect_to product_path(@product.id)
    else @product.nil?
      # flash[:status] = :failure
      # flash[:error] = "Unable to retire #{@product.name}."
      # render :edit, status: :bad_request
    end
  end
  
  private
  
  def product_params
    return params.require(:product).permit(:name, :description, :price, :photo_URL, :stock, :merchant_id, :categories)
  end
  
  def find_product
    @product = Product.find_by(id: params[:id])
    
    if @product.nil?
      head :not_found
      return
    end
  end
end