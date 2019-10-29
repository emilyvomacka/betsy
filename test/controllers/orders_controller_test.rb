require "test_helper"
require "pry"

describe OrdersController do 
  
  describe "order stored in session" do
    before do 
      new_params = {product_id: products(:seedy).id, quantity: 3}
      post order_items_path, params: new_params
      @new_order = Order.last
    end 
    
    describe "show" do
      it "succeeds for an extant order ID with cart_status: pending and order_id == session[:order_id]" do
        get order_path(@new_order.id)
        must_respond_with :success
      end
      
      it "responds with unauthorized when cart status is pending but order_id does not match session[:order_id]" do 
        second_order = orders(:a)
        get edit_order_path(second_order.id)
        must_respond_with :unauthorized
      end 
      
      it "responds with a bad_request when id given does not exist" do
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
      
      it "succeeds for an extant order ID with pending status whose ID matches session[:order_id]" do     
        get edit_order_path(@new_order)
        must_respond_with :success
      end
      
      it "responds with a not_found when extant order with pending status does not match session[:order_id]" do 
        second_order = orders(:a)
        get edit_order_path(second_order.id)
        must_respond_with :unauthorized
      end 
      
      it "responds with a bad_request when id given does not exist" do
        get edit_order_path(Order.last.id + 1000000000)
        must_respond_with :bad_request
      end
      
      it "responds with an unauthorized when order is no longer pending" do 
        paid_order = orders(:b)
        get edit_order_path(paid_order.id)
        must_respond_with :unauthorized
      end 
    end
    
    describe "update" do
      before do 
        @new_order_update_params = {
          order: {
            customer_name: "Sea Wolf",
            email_address: "seawolf@gmail.com",
            mailing_address: "1234 Happy Town, Seattle, WA",
            cc_number: "1111111111111111",
            cc_expiration: "12/20",
            cc_security_code: "123",
            zip_code: "99999",
            cart_status: "paid"
          }
        }
        new_params = {product_id: products(:seedy).id, quantity: 3}
        post order_items_path, params: new_params
        @new_order = Order.last 
      end 
      
      it "re-renders edit page if quantity wanted is greater than stock" do
        skip
        products(:seedy).stock = 2
        products(:seedy).reload
        
        patch order_path(@new_order.id), params: @new_order_update_params
        must_respond_with :bad_request 
        expect(@new_order.cart_status).must_equal "pending"      
      end
      
      it "changes cart status to paid and reduces stock for a legitimate order" do
        
        patch order_path(@new_order), params: @new_order_update_params
        @new_order.reload      
        
        expect(@new_order.cart_status).must_equal "paid"
        must_respond_with :redirect
        must_redirect_to products_path
        products(:seedy).reload
        expect(products(:seedy).stock).must_equal 18
      end
    end
  end 
end 

