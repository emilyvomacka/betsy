class OrderItemsController < ApplicationController
  
  def create #action to add to cart
    @new_order_item = OrderItem.create(order_product_params)
    # quantity: order_items_params["quantity"],
    # product_id: params["product_id"],
    # order_id: session[:order_id] )
    if Order.find_by(id: session[:order_id]).order_items << @new_order_item
      flash[:success] = "Item added to carb. Um, cart."
      redirect_to product_path(order_items_params["product_id"])
    else 
      flash.now[:danger] = "There is a problem. Sorry for the crumby UX."
    end 
  end
  
  def update #action to update quantity
  end
  
  
  def destroy #action to remove from cart
    @new_order_item = OrderItem.find_by(id: params[:id])
    if @new_order_item.destroy 
      flash[:success] = "That bread was toast! Successfully removed from order."
      redirect_to root_path
    else
      flash.now[:danger] = "There is a problem. Sorry for the crumby UX."
    end
  end
  
  
  private
  
  def order_items_params
    return params.require(:order_items).permit(:product_id, :order_id, :quantity) 
  end
  
end



end
