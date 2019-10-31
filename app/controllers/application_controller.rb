class ApplicationController < ActionController::Base
  before_action :current_merchant
  before_action :all_categories
  before_action :all_merchants
  
  def current_merchant
    @current_merchant = Merchant.find_by(id: session[:merchant_id])
  end
  
  def require_login
    if @current_merchant.nil?
      flash[:status] = :failure
      flash[:result_text] = "You must be logged in to view this page."
      redirect_back fallback_location: root_path
      return
    end
  end
  
  def find_order
    if params[:order_id]
      @order = Order.find_by(id: params[:order_id])
    elsif params[:id]
      @order = Order.find_by(id: params[:id])
    elsif session[:order_id] && session[:order_id] != nil
      @order = Order.find_by(id: session[:order_id])
    end 
    if @order.nil?
      flash.now[:status] = :danger
      flash.now[:result_text] = "Sorry, order not found."
      render 'products/main', status: :bad_request 
      return 
    end
  end
  
  def is_this_your_cart?
    if @order.cart_status == "pending" && @order.id != session[:order_id]
      flash.now[:status] = :danger
      flash.now[:result_text] = "You are not authorized to view this pending order."
      render 'products/main', status: :unauthorized 
      return 
    end 
  end 
  
  def still_pending?
    if ["paid", "completed", "cancelled"].include?(@order.cart_status)
      flash.now[:status] = :danger
      flash.now[:result_text] = "Sorry, you cannot modify a checked-out order."
      render 'products/main', status: :unauthorized
      return 
    end 
  end 
  
  def are_products_active?
    inactive_items = []
    @order.order_items.each do |item|
      if item.product.active == false
        inactive_items << item
      end 
    end 
    if inactive_items.any?
      inactive_items.each do |item|
        item.destroy
      end 
      flash.now[:status] = :danger
      flash.now[:result_text] = "Sorry, you have requested products that are now inactive on our site. We have removed them from your cart. Please carry on with your order!"
      render 'products/main', status: :bad_request 
      return 
    end 
  end 
  
  def find_product
    if params[:product_id]
      @product = Product.find_by(id: params[:product_id])
    else 
      @product = Product.find_by(id: params[:id])
    end 
    if @product.nil?
      head :not_found
      return
    end
  end
  
  private 
  
  def all_categories
    @all_categories = Category.all
  end
  
  def all_merchants
    @all_merchants = Merchant.all
  end
  
end
