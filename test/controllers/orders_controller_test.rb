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
end