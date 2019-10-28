class OrdersController < ApplicationController
  before_action :find_order, only: [:show, :edit, :update]
  
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
  
  #order_item create
  def add_to_cart
    new_quantity = params["quantity"]
    new_product_id = params["product_id"]
    if session[:order_id] == nil || session[:order_id] == false
      curr_order = Order.create(cart_status: "pending")
      session[:order_id] = curr_order.id
    else 
      curr_order = Order.find_by(id: session[:order_id])
    end 
    if new_quantity.to_i + curr_order.existing_quantity(new_product_id) > Product.find(new_product_id).stock
      redirect_to product_path(new_product_id)
      flash[:status] = :danger
      flash[:result_text] = "Error: excessive carb-loading. Please order less bread!"
      return 
    end 
    if curr_order.consolidate_order_items(new_product_id, new_quantity) == false 
      curr_order.order_items << OrderItem.create(
        quantity: new_quantity,
        product_id: new_product_id,
        order_id: curr_order.id)
      end 
      flash[:status] = :success
      flash[:result_text] = "Item added to shopping carb."
      redirect_to product_path(params["product_id"])
    end   
    
    #order_item destroy
    def delete_from_cart
      @order_item = OrderItem.find_by(id: params[:order_item_id])
      if @order_item.nil?
        flash[:error] = "Bread is missing"
        redirect_to order_path(session[:order_id])
      end 
      @order_item.destroy
      flash[:status] = :success
      flash[:result_text] = "Item deleted from carb."
      if session[:order_id]
        redirect_to order_path(session[:order_id])
      else 
        redirect_to root_path
      end 
    end 
    
    #order_item edit
    def edit_item_quantity
      @order_item = OrderItem.find_by(id: params[:order_item_id])
      if @order_item.nil?
        flash[:status] = :danger
        flash[:result_text] = "Bread is missing"
        redirect_to order_path(session[:order_id])
      end 
      if params[:new_quantity].to_i > @order_item.product.stock
        flash[:status] = :failure
        flash[:result_text] = "Bread overload. Please order less bread."
        redirect_to order_path(session[:order_id])
      else
        @order_item.quantity = params[:new_quantity]    
        @order_item.save 
        flash[:status] = :success
        flash[:result_text] = "Quantity adjusted"
        if session[:order_id]
          redirect_to order_path(session[:order_id])
        else 
          redirect_to root_path
        end 
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
  end
  