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
    if session[:order_id].nil?
      @order = Order.create(cart_status: "pending")
      session[:order_id] = @order.id
    end   
    new_order_item = OrderItem.create(
      quantity: params["quantity"],
      product_id: params["product_id"],
      order_id: session[:order_id] )
      if Order.find_by(id: session[:order_id]).order_items << new_order_item
        flash[:success] = "Item added to carb. Um, cart."
        redirect_to product_path(params["product_id"])
      else 
        flash.now[:failure] = "There is a problem. Sorry for the crumby UX."
      end 
    end 
  end 
  
  
  def edit #customers add check-out info
    @order = Order.find_by(id: session[:order_id])
    if @order.nil?
      flash[:warning] = "Order was not found. Add more bread to your carb."
      redirect_to root_path 
      return
    end
  end
  
  def update
    if @order.update(order_params) 
      #not sure how to add validations here (did customer fill in all fields?)
      @order.status = "paid"
      redirect_to root_path
      return
    else
      render :edit 
      return
    end
  end
  
  def destroy
    
    return
  end
  
  
  private
  
  def order_params
    return params.require(:order).permit(:mailing_address, :customer_name, :cc_number, :cc_expiration, :cc_security_code, :zip_code, :cart_status) 
  end
  
  
  
  