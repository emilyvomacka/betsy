class OrdersController < ApplicationController
  
  def index
  end
  
  def show
    @order = Order.find(params[:id])
    
    if @order.nil?
      head :not_found
      return
    end
  end
  
  #adding a product item to the cart 
  def add_to_cart
    new_quantity = params["quantity"]
    new_product_id = params["product_id"]
    if new_quantity.to_i > Product.find(new_product_id).stock
      redirect_to product_path(new_product_id)
      flash[:danger] = "Error: excessive carb-loading. Please order less bread!"
      return 
    end 
    if session[:order_id] == nil || session[:order_id] == false
      @order = Order.create(cart_status: "pending")
      session[:order_id] = @order.id
    else 
      @order = Order.find_by(id: session[:order_id])
    end 
    #if @order.consolidate_order_items returns error, 
    #flash[:danger] = "Error: excessive carb-loading. Please order less bread!"
    if @order.consolidate_order_items(new_product_id, new_quantity) == false 
      @order.order_items << OrderItem.create(
      quantity: new_quantity,
      product_id: new_product_id,
      order_id: @order.id)
    end 
    flash[:success] = "Item added to shopping carb."
    redirect_to product_path(params["product_id"])
  end   
  
  
  def edit #customers add check-out info
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      flash[:warning] = "Order was not found. Add more bread to your carb."
      redirect_to root_path 
      return
    end
  end 
  
  def update
    @order = Order.find_by(id: params[:id])
    @order.order_items.each do |item|
      if item.quantity > item.product.stock
        flash.now[:error] = "#{item.product.name} running low! We currently only have #{item.product.stock} left. Please adjust your order."
        render :edit
        return 
      end 
    end 
    if @order.update(order_params) 
      @order.cart_status = "paid"
      @order.save 
      redirect_to products_path
      flash[:success] = "Order submitted! Bread ahead."
      session[:order_id] = nil
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
    return params.require(:order).permit(:mailing_address, :customer_name, :cc_number, :cc_expiration, :cc_security_code, :zip_code, :cart_status) 
  end
  
end
