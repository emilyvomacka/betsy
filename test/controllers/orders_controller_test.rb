require "test_helper"

describe OrdersController do 
  let (:existing_order) { orders(:a) }
  
  describe "show" do
    it "succeeds for an extant order ID" do
      get order_path(existing_order)
      must_respond_with :success
    end
    
    it "responds with a not_found when id given does not exist" do
      get order_path(-58437)
      must_respond_with :not_found
    end
  end 
  
  describe "edit" do
    it "succeeds for an extant order ID" do
      get edit_order_path(existing_order)
      must_respond_with :success
    end
    
    it "responds with a not_found when id given does not exist" do
      get edit_order_path(Order.last.id + 1000000000)
      must_respond_with :not_found
    end
  end
  
  describe "update" do
    it "re-renders edit page if quantity wanted is greater than stock" do
      existing_order_params = {
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
      
      
      products(:daily_baguette).stock = 2
      products(:daily_baguette).reload
      
      expect(patch order_path(existing_order.id), params: existing_order_params)
      expect(existing_order.cart_status).must_equal "pending"      
    end
    
    it "changes cart status to paid" do
      existing_order_params = {
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
      
      patch order_path(existing_order), params: existing_order_params
      existing_order.reload      
      
      expect(existing_order.cart_status).must_equal "paid"
      must_respond_with :redirect
      must_redirect_to products_path
    end
    
    it "reduces quantity in stock after order has been confirmed" do
      existing_order_params = {
        order: {
          quantity: 1,
          product: "daily_baguette"
        }
      }
      expect(patch order_path(existing_order.id), params: existing_order_params)   
      expect(products(:daily_baguette).stock).must_equal 39      
    end
  end
  
end

