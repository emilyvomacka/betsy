class OrderItemsController < ApplicationController
  # before_action :find_order
  before_action :find_order, except: :create
  before_action :is_this_your_cart?, except: :create
  before_action :still_pending?, except: :create
  before_action :find_order_item, except: :create 
  
  def create #add to cart
    new_quantity = params["quantity"]
    new_product_id = params["product_id"]
    if session[:order_id] == nil || session[:order_id] == false || !session[:order_id]
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
  
  def update #change quantity
    @order_item.quantity = params[:new_quantity]    
    @order_item.save 
    flash[:status] = :success
    flash[:result_text] = "Quantity adjusted"
    redirect_to order_path(session[:order_id])
  end 
  
  def destroy #delete from cart
    @order_item.destroy
    flash[:status] = :success
    flash[:result_text] = "Item deleted from carb."
    if session[:order_id]
      redirect_to order_path(session[:order_id])
    else 
      redirect_to root_path
    end 
  end 
  
  private
  
  def order_item_params
    return params.require(:order_item).permit(:quantity, :product_id) 
  end

  def find_order_item
    @order_item = OrderItem.find_by(id: params[:id])
    if @order_item.nil?
      redirect_to root_path, status: :bad_request 
      return 
    end 
  end 
end