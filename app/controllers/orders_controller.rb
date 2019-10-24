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
  
  def new 
    @order = Order.new
  end 

  def create
    @order = Order.new(order_params)
    if @order.save 
      flash[:success] = "The Bread Express has left the station."
      session[:order_id] = @order.id
      redirect_to order_path(@order.id) 
      return
    else # save failed :(
      flash.now[:failure] = "Order failed to save. Sorry for the crumby UX."
      redirect_to root_path
    end
    #update stock of products on site once order items have been purchased. 
  end

  def edit
    @order = Order.find_by(id: session[:order_id])
    if @order.nil?
      flash[:warning] = "Order was not found. Add more bread to your carb please."
      redirect_to root_path 
      return
    end
  end

  def update
   
  end

  def destroy 
    @order = Order.find_by(id: session[:order_id])
    if @order.nil?
      flash[:warning] = "Order was not found."
      redirect_to root_path 
      return
    elsif @order.status != "paid"
      flash[:warning] = "Unable to cancel order. Enjoy!"
      redirect_to root_path
      return 
    end 
    @order.destroy
    redirect_to root_path
    flash[:success] = "Order successfully cancelled."
  end

  private

  def order_params
    return params.require(:order).permit(:mailing_address, :customer_name, :cc_number, :cc_expiration, :cc_security_code, :zip_code, :cart_status) 
  end

end