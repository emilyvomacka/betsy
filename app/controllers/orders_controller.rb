class OrdersController < ApplicationController
  before_action :find_order, except: [:find]
  before_action :is_this_your_cart?, except: [:find]
  before_action :still_pending?, except: [:show, :find, :search]
  before_action :are_products_active?, only: [:update]
  before_action :does_order_have_items?, only: [:update]
  
  def show ; end
  
  def edit ; end 
  
  def update
    @order.order_items.each do |item|
      if item.quantity > item.product.stock
        flash.now[:status] = :failure
        flash.now[:result_text] = "#{item.product.name} running low! We currently only have #{item.product.stock} left. Please adjust your order."
        render :edit, status: :bad_request 
        return 
      end 
    end 
    if @order.update(order_params) 
      @order.cart_status = "paid"
      @order.save 
      session.delete(:order_id)
      @order.order_items.each do |item|
        item.product.stock -= item.quantity 
        item.product.save 
      end 
      flash[:status] = :success
      flash[:result_text] = "Order submitted! Bread ahead."
      redirect_to order_path(@order)
      return
    else
      render :edit 
      return
    end
  end
  
  def search
    render action: 'show'
  end
  
  private
  
  def does_order_have_items?
    if @order.order_items.empty?
      flash.now[:status] = :danger
      flash.now[:result_text] = "Your order is bad and you should feel bad."
      render 'products/main', status: :bad_request
      return  
    end 
  end 
  
  
  def order_params
    return params.require(:order).permit(:mailing_address, :email_address, :customer_name, :cc_number, :cc_expiration, :cc_security_code, :zip_code, :cart_status) 
  end
end
