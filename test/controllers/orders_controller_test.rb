require "test_helper"

describe OrdersController do
  let(:existing_order) { orders(:a) }
  
  describe "index" do
    it "succeeds when there are orders" do
      get orders_path
      
      must_respond_with :success
    end
    
    it "succeeds when there are no orders" do
      Order.all do |order|
        order.destroy
      end
      
      get orders_path
      
      must_respond_with :success
    end
  end
  
  describe "new" do
    it "succeeds" do
      get new_order_path
      
      must_respond_with :success
    end
  end
  
  describe "create" do
    it "creates an order with valid data for a real category" do
      new_order = { order: { merchant_id: 1 } }
      
      expect {
        post orders_path, params: new_order
      }.must_change "Order.count", 1
      
      new_order_id = Order.find_by( merchant_id: 1 ).id
      
      must_respond_with :redirect
      must_redirect_to order_path(new_order_id)
    end
    
    it "renders bad_order and does not update the DB for bogus data" do
      bad_order = { order: { merchant_id: nil } }
      
      expect {
        post orders_path, params: bad_order
      }.wont_change "Order.count"
      
      must_respond_with :bad_request
    end
    
    # it "renders 400 bad_request for bogus categories" do
    #   INVALID_CATEGORIES.each do |category|
    #     invalid_work = { work: { title: "Invalid Work", category: category } }
    
    #     proc { post works_path, params: invalid_work }.wont_change "Work.count"
    
    #     Work.find_by(title: "Invalid Work", category: category).must_be_nil
    #     must_respond_with :bad_request
    #   end
  end
  
  
  # describe "show" do
  #   it "succeeds for an extant order ID" do
  #     get order_path(existing_order.id)
  
  #     must_respond_with :success
  #   end
  
  #   it "renders 404 not_found for a bogus order ID" do
  #     destroyed_id = existing_order.id
  #     existing_order.destroy
  
  #     get order_path(destroyed_id)
  
  #     must_respond_with :not_found
  #   end
  # end
  
  # describe "edit" do
  #   it "succeeds for an extant order ID" do
  #     get edit_order_path(existing_order.id)
  
  #     must_respond_with :success
  #   end
  
  #   it "renders 404 not_found for a bogus order ID" do
  #     bogus_id = existing_order.id
  #     existing_order.destroy
  
  #     get edit_order_path(bogus_id)
  
  #     must_respond_with :not_found
  #   end
  # end
  
  # describe "update" do
  #   it "succeeds for valid data and an extant order ID" do
  #     updates = { order: { merchant_id: 2 } }
  
  #     expect {
  #       put order_path(existing_order), params: updates
  #     }.wont_change "Order.count"
  #     updated_order= Order.find_by(id: existing_order.id)
  
  #     updated_order.merchant_id.must_equal 2
  #     must_respond_with :redirect
  #     must_redirect_to order_path(existing_order.id)
  #   end
  
  #   it "renders bad_request for bogus data" do
  #     updates = { order: { merchant_id: nil } }
  
  #     expect {
  #       put order_path(existing_order), params: updates
  #     }.wont_change "Order.count"
  
  #     order = Order.find_by(id: existing_order.id)
  
  #     must_respond_with :not_found
  #   end
  
  #   it "renders 404 not_found for a bogus order ID" do
  #     bogus_id = existing_order.id
  #     existing_order.destroy
  
  #     put order_path(bogus_id), params: { order: { merchant_id: 100000000 } }
  
  #     must_respond_with :not_found
  #   end
  # end
  
  # describe "destroy" do
  #   it "succeeds for an extant order ID" do
  #     expect {
  #       delete order_path(existing_order.id)
  #     }.must_change "Order.count", -1
  
  #     must_respond_with :redirect
  #     must_redirect_to root_path
  #   end
  
  #   it "renders 404 not_found and does not update the DB for a bogus order ID" do
  #     bogus_id = existing_order.id
  #     existing_order.destroy
  
  #     expect {
  #       delete order_path(bogus_id)
  #     }.wont_change "Order.count"
  
  #     must_respond_with :not_found
  #   end
end

