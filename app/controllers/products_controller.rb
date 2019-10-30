class ProductsController < ApplicationController 
  before_action :find_product, only: [:show, :edit, :update, :retire]
  before_action :require_login, except: [:index, :main, :show]
  before_action :check_authorization, only: [:edit, :update, :retire]
  
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
    @product.merchant_id = session[:merchant_id]
    
    if @product.save
      flash[:status] = :success
      flash[:success] = "Successfully created product #{@product.name}."
      redirect_to product_path(@product)
      return
    else
      flash.now[:status] = :failure
      flash.now[:error] = "Unable to create product #{@product.name}."
      flash.now[:messages] = @product.errors.messages
      render :new, status: :bad_request
      return
    end
  end
  
  def edit; end
  
  def update
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
    if @product.retire
      if @product.active == true
        flash[:status] = :success
        flash[:result_text] = "Successfully reactivated #{@product.name}."
      else
        flash[:status] = :success
        flash[:result_text] = "Successfully retired product #{@product.name}."
      end
      redirect_to product_path(@product.id)
      return
    else @product.nil?
      flash.now[:status] = :danger
      flash.now[:result_text] = "Unable to retire #{@product.name}."
      render :edit, status: :bad_request
      return
    end
  end
  
  private
  
  def product_params
    return params.require(:product).permit(:name, :description, :price, :photo_URL, :stock, :merchant_id, :active, category_ids: [])
  end
  
  def find_product
    @product = Product.find_by(id: params[:id])
    
    if @product.nil?
      head :not_found
      return
    end
  end
  
  def check_authorization
    if @product.merchant_id != @current_merchant.id
      flash[:status] = :danger
      flash[:result_text] = "You are not authorized to view this page."
      redirect_to root_path
      return
    end
  end
end