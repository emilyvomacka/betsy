class OrdersController < ApplicationController
  
  def index
    if params[:merchant_id]
      # This is the nested route, /author/:author_id/books
      merchant = Merchant.find_by(id: params[:merchant_id])
      if merchant.nil?
        redirect_to merchants_path
      end
      
      @orders = merchant.orders
      
    else
      # This is the 'regular' route, /books
      @orders = Order.all #Book.all
    end
  end
  
  def show
  end
  
  def new
    if params[:merchant_id]
      # This is the nested route, /author/:author_id/books/new
      merchant = Merchant.find_by(id: params[:merchant_id])
      @order = merchant.orders.new
      
    else
      # This is the 'regular' route, /books/new
      @order = Order.new
    end
  end
  
  def create
    @order = Order.new(order_params)
    if @order.save # save returns true if the database insert succeeds
      flash[:success] = "Order  successfully"
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
  
  def read
  end
  
  def edit ;
  end
  
  def destroy
    @order.destory
    redirect_to orders_path
  end
  
  private
  
  def order_params
    return params.require(:order).permit(:merchant_id) #will require personal info to submit order?
    #order status
  end
  
end
