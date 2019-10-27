class OrdersController < ApplicationController
  
  # def index
  # end
  
  def show
    @order = Order.find(params[:id])
    
    if @order.nil?
      head :not_found
      return
    end
  end
  
  #adding a product item to the cart 
  def add_to_cart
    if params["quantity"].to_i > Product.find(params["product_id"]).stock
      redirect_to product_path(params["product_id"])
      flash[:danger] = "Error: excessive carb-loading. Please order less bread!"
      return 
    end 
    if session[:order_id] == nil
      @order = Order.create(cart_status: "pending")
      session[:order_id] = @order.id
    end   
    # new_order_item = OrderItem.create(
    #   quantity: params["quantity"],
    #   product_id: params["product_id"],
    #   order_id: session[:order_id] )
    #   if Order.find_by(id: session[:order_id]).order_items << new_order_item
    #     flash[:success] = "Item added to carb. Um, cart."
    #     redirect_to product_path(params["product_id"])
    #   else 
    #     flash.now[:danger] = "There is a problem. Sorry for the crumby UX."
    #   end 
    #end
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
    if @order.update(order_params) 
      #not sure how to add validations here (did customer fill in all fields?)
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
  
  
  