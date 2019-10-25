require "test_helper"

describe Order do
  let(:order) { orders(:a) }
  describe "relationships" do 
    it "has many order items" do 
      expect(order).must_respond_to :order_items
    end
    
  end
end
# it "does a thing" do
#   value(1+1).must_equal 2
# end

describe "custom methods" do
  describe "total_cost" do
    it "adds up total costs of an order" do 
      expect(orders(:a).total_cost).must_equal 0.11575e3
    end 
    
    it "calculates a new total when additional items are added to an order" do
      new_item = OrderItem.new(quantity: 1, product: products(:baguette), order: orders(:a))
      orders(:a).order_items << new_item 
      expect(orders(:a).total_cost).must_equal 0.1197e3
    end 
  end 
  
  # describe "determine_status" do
  #   it "sets status of a same-day order to paid" do
  #     orders(:a).created_at = DateTime.now 
  #     expect(orders(:a).determine_status).must_equal "paid"
  #   end 
  
  # it "sets status of an order made more than 1 day ago to complete" do
  #   orders(:a).created_at = DateTime.new(2019, 10, 1)
  #   expect(:orders(:a).determine_status).must_equal "complete"
  # end 
  # end 
end 


