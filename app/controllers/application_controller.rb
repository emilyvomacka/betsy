class ApplicationController < ActionController::Base
  before_action :current_merchant
  
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
  
  #order/order items authorizations
  
  def find_order
    #this is the nested route
    if params[:order_id]
      @order = Order.find_by(id: params[:order_id])
    else
      #non-nested
      @order = Order.find_by(id: params[:id])
    end 
    if @order.nil?
      flash[:status] = :danger
      flash[:result_text] = "Sorry, order not found."
      render 'products/main', status: :bad_request 
      return 
    end
  end
  
  def is_this_your_cart?
    if @order.cart_status == "pending" && @order.id != session[:order_id]
      flash[:status] = :danger
      flash[:result_text] = "You are not authorized to view this pending order."
      render 'products/main', status: :unauthorized 
      return 
    end 
  end 
  
  def still_pending?
    if ["paid", "completed", "cancelled"].include?(@order.cart_status)
      flash[:status] = :danger
      flash[:result_text] = "Sorry, you cannot modify a checked-out order."
      render 'products/main', status: :unauthorized
      return 
    end 
  end 
end
