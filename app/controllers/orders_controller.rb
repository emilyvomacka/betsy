class OrdersController < ApplicationController
  before_action :find_order
  before_action :is_this_your_cart?
  before_action :have_you_checked_out?, except: :show
  
  def show ; end
  
  def edit ; end 
  
  def update
    @order.order_items.each do |item|
      if item.quantity > item.product.stock
        flash[:status] = :failure
        flash[:result_text] = "#{item.product.name} running low! We currently only have #{item.product.stock} left. Please adjust your order."
        render :edit
        return 
      end 
    end 
    if @order.update(order_params) 
      @order.cart_status = "paid"
      @order.save 
      redirect_to products_path
      flash[:status] = :success
      flash[:result_text] = "Order submitted! Bread ahead."
      session.delete(:order_id)
      @order.order_items.each do |item|
        item.product.stock -= item.quantity 
        item.product.save 
      end 
      return
    else
      render :edit 
      return
    end
  end
  
  private
  
  def order_params
    return params.require(:order).permit(:mailing_address, :email_address, :customer_name, :cc_number, :cc_expiration, :cc_security_code, :zip_code, :cart_status) 
  end
  
  def find_order
    @order = Order.find_by(id: params[:id])
    
    if @order.nil?
      head :not_found
      return
    end
  end

  def is_this_your_cart?
    if @order.cart_status == "pending" && @order.id != session[:order_id]
      head :not_found
      return 
    end 
  end 

  def have_you_checked_out?
    if ["paid", "completed", "cancelled"].include?(@order.cart_status)
      head :not_found
      return
    end 
  end 
end
