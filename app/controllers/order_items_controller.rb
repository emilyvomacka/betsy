class OrderItemsController < ApplicationController

  before_action :find_order, except: :create
  before_action :is_this_your_cart?, except: :create
  before_action :still_pending?, except: :create
  before_action :find_order_item, except: :create 
  before_action :are_products_active?, except: [:destroy, :create]
  before_action :find_product, only: :create
  before_action :active_product?, only: :create

  def create 
    new_quantity = params["quantity"]
    new_product_id = params["product_id"]
    #if product.status != active, return 
    if session[:order_id] == nil || session[:order_id] == false || !session[:order_id]
      @order = Order.create(cart_status: "pending")
      session[:order_id] = @order.id
    else 
      @order = Order.find_by(id: session[:order_id])
    end 
    if new_quantity.to_i + @order.existing_quantity(new_product_id) > Product.find(new_product_id).stock
      flash.now[:status] = :danger
      flash.now[:result_text] = "Error: excessive carb-loading. Please order less bread!"
      render 'products/main', status: :bad_request 
      return 
    end 
    if @order.consolidate_order_items(new_product_id, new_quantity) == false 
      @order.order_items << OrderItem.create(
      quantity: new_quantity,
      product_id: new_product_id,
      order_id: @order.id)
    end 
    flash[:status] = :success
    flash[:result_text] = "Item added to shopping carb."
    redirect_to product_path(params["product_id"])
    return 
  end
  
  def update 
    @order_item.quantity = params[:new_quantity]    
    @order_item.save 
    flash[:status] = :success
    flash[:result_text] = "Quantity adjusted"
    redirect_to order_path(session[:order_id])
  end 
  
  def destroy 
    @order_item.destroy
    flash.now[:status] = :success
    flash.now[:result_text] = "Item deleted from carb."
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
  
  def active_product?
    if @product.active != true
      flash.now[:status] = :danger
      flash.now[:result_text] = "Sorry, this product is inactive and cannot be added to your cart."
      render 'products/main', status: :bad_request
      return 
    end 
  end 
end