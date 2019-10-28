require "test_helper"

describe OrderItem do
  let(:order_item) { order_items(:one) }
  
  it "can be instantiated" do
    # Assert
    expect(order_item.valid?).must_equal true
  end
  
  describe "validations" do
    it 'is valid when all fields are present' do
      order_item = order_items(:one)
      result = order_item.valid?
      
      expect(result).must_equal true
    end
    
    it 'is invalid with a quantity of zero or less' do
      order_item = order_items(:one)
      order_item.quantity = 0
      result = order_item.valid?
      expect(result).must_equal false
    end
    
    it 'is valid with a quantity greater than zero' do
      order_item = order_items(:one)
      result = order_item.valid?
      expect(result).must_equal true
    end
    
    it 'is invalid with a quantity that is not an integer' do
      order_item = order_items(:one)
      order_item.quantity = 1.5
      result = order_item.valid?
      expect(result).must_equal false
    end
    
    it 'is invalid with a quantity that is not present' do
      order_item = order_items(:one)
      order_item.quantity = nil
      result = order_item.valid?
      expect(result).must_equal false
    end
  end
  
  describe "relations" do
    it "has a product" do
      one = order_items(:one)
      _(one).must_respond_to :product
      _(one.product).must_be_kind_of Product
    end
    
    it "has an order" do
      one = order_items(:one)
      _(one).must_respond_to :order
      _(one.order).must_be_kind_of Order
    end
  end
  
  describe "custom methods" do
    describe "total" do
      it "will return the total for an order item" do
        expect(order_items(:one).total).must_equal order_items(:one).quantity*order_items(:one).product.price
        expect(order_items(:two).total).must_equal order_items(:two).quantity*order_items(:two).product.price
      end
    end
    
    describe "arrange_by_created_at" do
      it 'properly arranges the items by their created_at order' do
        test_list = OrderItem.arrange_by_created_at 
        expect( test_list[0]).must_equal order_items(:one)
        expect( test_list[-1]).must_equal order_items(:five)
      end
    end 
  end
end


