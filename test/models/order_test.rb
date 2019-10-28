require "test_helper"

describe Order do
  let(:existing_order) {orders(:a)}
  
  describe "relationships" do 
    it "has many order items" do 
      expect(existing_order).must_respond_to :order_items
    end
  end
  
  describe "validations" do 
    
  end 
  
  describe "custom methods" do
    describe "total_cost" do
      it "adds up total costs of an order" do 
        expect(existing_order.total_cost).must_equal 0.11575e3
      end 
      
      it "calculates a new total when additional items are added to an order" do
        new_item = OrderItem.new(quantity: 1, product: products(:baguette), order: existing_order)
        existing_order.order_items << new_item 
        expect(existing_order.total_cost).must_equal 0.1197e3
      end 
      
      it "returns 0 when there are no order items" do
        existing_order.order_items.destroy_all
        expect(existing_order.total_cost).must_equal 0
      end 
    end 
    
    describe "consolidate order items" do
      it "returns false when a new order item does not share a product id with existing order items" do
        expect(existing_order.consolidate_order_items(products(:seedy).id, 1)).must_equal false 
      end 
      
      it "returns true when a new order item shares a product id with existing order items, and +='s the existing order item's quantity accordingly" do 
        expect(existing_order.consolidate_order_items(products(:daily_baguette).id, 1)).must_equal true
        expect(order_items(:one).quantity).must_equal 2
      end 
      
      it "returns false when an order has no existing items" do 
        existing_order.order_items.destroy_all
        expect(existing_order.consolidate_order_items(products(:daily_baguette).id, 1)).must_equal false 
      end
      
    end 
    
    describe "return merchant items" do
      it "returns an array of all merchant items from an order" do 
        expect(existing_order.return_merchant_items(1)).must_equal [order_items(:one), order_items(:two)]
      end 
      
      it "returns an empty array when merchant has no items in an order" do
        expect(existing_order.return_merchant_items(2)).must_be_empty
      end 
    end 
    
    describe "return merchants" do
      it "returns an array of all merchants involved in a given order" do
        expect(existing_order.return_merchants).must_equal [merchants(:sea_wolf)]
      end 
      
      it "returns an empty array when an order has no order items" do 
        existing_order.order_items.destroy_all
        expect(existing_order.return_merchants).must_be_empty
      end 
    end 
    
    describe "existing quantity" do
      it "return the quantity of a product currently existing in an order" do
        expect(existing_order.existing_quantity(1)).must_equal 4
      end 
      it "returns 0 when an order does not contain the given product" do
        expect(existing_order.existing_quantity(2)).must_equal 0
      end 
    end
  end 
end 