require "test_helper"

describe OrdersController do 
  let(:order) { orders(:a) }
  
  describe "show" do
    it "succeeds for an extant order ID" do
      get order_path(order.id)
      
      must_respond_with :success
    end
    
    
  end
end