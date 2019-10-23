class OrdersController < ApplicationController
  
  def index
  end
  
  def show
  end
  
  def new
    
  end
  
  def create
    @order = Order.new(order_params)
    if @order.save # save returns true if the database insert succeeds
      flash[:success] = "Order made successfully"
      redirect_to root_path # go to the index so we can see the order in the list
      return
    else # save failed :(
      flash.now[:failure] = "Order failed to save"
      render :new # show the new order form view again
      return
    end
  end
  
  
  def update
    if @order.update(order_params)
      redirect_to root_path # go to the index so we can see the book in the list
      return
    else # save failed :(
      render :edit # show the new book form view again
      return
    end
  end
  
  
  def edit
  end
  
  
  
  private
  
  def order_params
    return params.require(:order).permit(:mailing_address, :customer_name, :cc_number, :cc_expiration, :cc_security_code, :zip_code, :cart_status) 
  end
  
end