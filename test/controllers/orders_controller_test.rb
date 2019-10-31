require "test_helper"
require "pry"

describe OrdersController do 

  before do 
    new_params = {product_id: products(:seedy).id, quantity: 3}
    post order_items_path, params: new_params
    @new_order = Order.last
  end 
  
  describe "show" do
    it "succeeds for an extant order ID when order.cart_status == pending and order_id == session[:order_id]" do
      get order_path(@new_order)
      must_respond_with :success
    end
    
    it "responds with unauthorized when order.cart_status = pending but order_id != session[:order_id]" do 
      get edit_order_path(orders(:a))
      must_respond_with :unauthorized
    end 
    
    it "responds with a bad_request when order ID is invalid" do
      get order_path(-58437)
      must_respond_with :bad_request
    end
  end 
  
  describe "edit" do
    before do 
      new_params = {product_id: products(:seedy).id, quantity: 3}
      post order_items_path, params: new_params
      @new_order = Order.last
    end
    
    it "succeeds when order.cart_status == pending and order.id == session[:order_id]" do     
      get edit_order_path(@new_order)
      must_respond_with :success
    end
    
    it "responds with :unauthorized when order.cart_status == pending but order.id != session[:order_id]" do 
      get edit_order_path(orders(:a))
      must_respond_with :unauthorized
    end 

    it "responds with :unauthorized when order.cart_status != pending" do 
      get edit_order_path(orders(:b))
      must_respond_with :unauthorized
    end 
    
    it "responds with :bad_request when order ID is invalid" do
      get edit_order_path(Order.last.id + 1000000000)
      must_respond_with :bad_request
    end
  end
  
  describe "update" do
    before do
      @update_params = {
        order: {
          customer_name: "Sea Wolf",
          email_address: "seawolf@gmail.com",
          mailing_address: "1234 Happy Town, Seattle, WA",
          cc_number: "1111111111111111",
          cc_expiration: "12/20",
          cc_security_code: "123",
          zip_code: "99999",
          cart_status: "paid"}
      }
      new_params = {product_id: products(:seedy).id, quantity: 3}
      post order_items_path, params: new_params
      @new_order = Order.last 
    end 
    
    it "completes order with valid params when order.cart_status == pending and order.id == session[:order_id]" do
      patch order_path(@new_order), params: @update_params
      @new_order.reload      
      
      expect(@new_order.cart_status).must_equal "paid"
      must_respond_with :redirect
      must_redirect_to order_path(@new_order)
      products(:seedy).reload
      expect(products(:seedy).stock).must_equal 18
    end
    
    it "re-renders edit page if any order item's quantity is greater than its product's stock" do
      products(:seedy).stock = 2
      products(:seedy).save
      
      patch order_path(@new_order), params: @update_params
      must_respond_with :bad_request 
      expect(flash[:status]).must_equal :failure
      expect(@new_order.cart_status).must_equal "pending"      
    end

    it "will not let user check out if an order item has changed status to inactive" do
      products(:seedy).retire
      products(:seedy).save
      patch order_path(@new_order), params: @update_params
      must_respond_with :bad_request
    end

    it "responds with :unauthorized if order.id != session[:order_id]" do
      patch order_path(orders(:a)), params: @update_params
      must_respond_with :unauthorized
    end 
    
    it "will not let user check out when cart status != pending" do
      patch order_path(@new_order), params: @update_params
      patch order_path(@new_order), params: @update_params
      must_respond_with :unauthorized
    end 
    
    it "responds with :bad_request when order ID is invalid" do 
      patch order_path(-1), params: @update_params
      must_respond_with :bad_request
    end  
  end
  
  describe "search" do 
    it "renders show page for a valid id" do
      get search_order_path, params: {id: orders(:b).id}
      must_respond_with :success
    end 
    
    it "responds with :bad_request when order ID is invalid" do
      get search_order_path, params: {id: -1}
      must_respond_with :bad_request
    end 
  end 
end 
  
  
