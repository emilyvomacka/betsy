require "test_helper"

describe Order do
  let(:order) { orders(:a) }
  describe "relationships" do 
    it "has many order items" do 
      expect(order).must_respond_to :order_items
    end
    
  end
end