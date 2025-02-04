class OrdersController < ApplicationController
  before_action :find_order, except: [:find]
  before_action :is_this_your_cart?, except: [:find]
  before_action :still_pending?, except: [:show, :find, :search]
  before_action :are_products_active?, only: [:update]
  before_action :does_order_have_items?, only: [:update]
  
  def show ; end
  
  def edit ; end 
  
  def update
    result = @order.check_stock
    if result.any?
      result.each do |entry|
        flash.now[:status] = :failure
        flash.now[:result_text] = "#{entry[0]} running low! We currently only have #{entry[1]} left. Please adjust your order."
      end 
      render :edit, status: :bad_request 
      return
    end
    if @order.update(order_params) 
      @order.cart_status = "paid"
      @order.save 
      session.delete(:order_id)
      @order.decrement_stock 
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
      flash.now[:result_text] = "This order has no items to check out."
      render 'products/main', status: :bad_request
      return  
    end 
  end 
  
  def order_params
    return params.require(:order).permit(:mailing_address, :email_address, :customer_name, :cc_number, :cc_expiration, :cc_security_code, :zip_code, :cart_status) 
  end
end
