require "test_helper"

describe OrderItemsController do
  before do 
    @order = orders(:a)
  end 
  
  describe "create order item" do
    before do
      @order_launching_item_params = {product_id: products(:baguette).id, quantity: 2}
      @new_params = {product_id: products(:seedy).id, quantity: 3}
    end 
    
    it "creates a new order for incoming order item when order doesn't exist in the session" do
      expect{post order_items_path, params: @new_params}.must_change "Order.count", 1
      must_respond_with :redirect
    end 
    
    it "adds new order item to an existing order when order_id is stored in session" do
      post order_items_path, params: @order_launching_item_params
      
      expect{post order_items_path, params: @new_params}.must_change "OrderItem.count", 1
      must_respond_with :redirect
    end 
    
    it "doesn't modify order when combined quantity of order items exceeds available stock" do 
      post order_items_path, params: @order_launching_item_params
      
      bad_params = {product_id: products(:seedy).id, quantity: 3000}
      expect{post order_items_path, params: bad_params}.wont_change "OrderItem.count"
      must_respond_with :bad_request
      
      curr_order = Order.find_by(id: session[:order_id])
      expect(curr_order.order_items.count).must_equal 1
      expect(curr_order.total_cost).must_equal 0.79e1
    end 
    
    it "adds to an existing order item if new product id already exists in the order" do 
      post order_items_path, params: @order_launching_item_params
      duplicate_product_params = {product_id: products(:baguette).id, quantity: 2}
      expect{post order_items_path, params: duplicate_product_params}.wont_change "OrderItem.count"
      curr_order = Order.find_by(id: session[:order_id])
      expect(curr_order.order_items.count).must_equal 1
      expect(curr_order.total_cost).must_equal 0.158e2
    end 
  end 
  
  describe "update" do
    before do
      new_item_params = {product_id: products(:baguette).id, quantity: 2}
      
      post order_items_path, params: new_item_params
      
      @my_order = Order.find_by(id: session[:order_id])
      @my_order_item = @my_order.order_items.first
    end 
    
    it "updates an order item's quantity when requested" do
      update_params = {new_quantity: 5}
      expect{patch order_order_item_path(@my_order, @my_order_item), params: update_params}.wont_change "OrderItem.count"
      must_redirect_to order_path(@my_order)
      
      @my_order_item.reload
      expect(@my_order_item.quantity).must_equal 5
    end 
    
    it "responds :bad_request when asked to update the quantity of an invalid order item" do
      update_params = {new_quantity: 5}
      expect {patch order_order_item_path(@my_order, -1), params: update_params}.wont_change OrderItem.count
      must_respond_with :bad_request
    end 

    it "responds :bad_request when asked to update the quantity of an order item that has been retired" do
      @my_order_item.product.retire
      @my_order_item.save
      
      update_params = {new_quantity: 5}
      expect {patch order_order_item_path(@my_order, @my_order_item), params: update_params}.wont_change OrderItem.count
      must_respond_with :bad_request
    end 
  end 
  
  describe "destroy" do
    let (:order_item) {order_items(:one)}

    it "deletes an order item with valid input, and redirects to the current order's show page when session contains an order_id" do
      order_launching_item_params = {product_id: products(:baguette).id, quantity: 2}
      post order_items_path, params: order_launching_item_params

      current_order = Order.find_by(id: session[:order_id])
      current_item = current_order.order_items.first

      expect {delete order_order_item_path(current_order, current_item)}.must_change 'OrderItem.count', -1
      must_respond_with :redirect
      must_redirect_to order_path(current_order)
      assert_nil(OrderItem.find_by(id: current_item.id))
    end 

    it "does not delete an order item if the pending order does not belong to user" do 
      expect {delete order_order_item_path(orders(:a), order_item)}.wont_change 'OrderItem.count' 
      must_respond_with :unauthorized
    end 
    
    it "redirects when requested to delete an order item with invalid id" do
      first_item_params = {product_id: products(:baguette).id, quantity: 2}
      post order_items_path, params: first_item_params

      current_order = Order.find_by(id: session[:order_id])
      
      expect { delete order_order_item_path(current_order, -2948)}.wont_change "OrderItem.count"
      must_respond_with :bad_request
    end 
    
  end 
end
