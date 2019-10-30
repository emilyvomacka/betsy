class OrdersController < ApplicationController
  before_action :find_order
  
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
      redirect_to order_path(@order)
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
  
  def lookup
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
end
