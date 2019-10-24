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
  
  def create
    order_params = { 
    order: {
    email_address: nil,
    mailing_address: nil,
    customer_name: nil,
    cc_number: nil, 
    cc_expiration: nil,
    cc_security_code: nil,
    zip_code: nil,
    cart_status: "pending"
      }
    }
    @order = Order.new(order_params)
    if @order.save # save returns true if the database insert succeeds
      flash[:success] = "First item added to carb. Um, cart."
      session[:order_id] = @order.id
      redirect_to root_path # go to the index so we can see the order in the list
      return
    else # save failed :(
      flash.now[:failure] = "Order failed to save. Sorry for the crumby UX."
      redirect_to root_path
    end
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