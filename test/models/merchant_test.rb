require "test_helper"

describe Merchant do
  let (:merchant) {merchants(:nouveau)}
  
  describe "validations" do
    
    it "is valid with a name" do
      expect(merchant.valid?).must_equal true
    end
    
    it "is invalid without a name" do
      merchant.name = nil
      
      expect(merchant.valid?).must_equal false
      expect(merchant.errors.messages).must_include :name
    end
    
    it 'is invalid without a unique name' do
      invalid_merchant = Merchant.create(name: "Sea Wolf Bakers")
      
      expect(invalid_merchant.valid?).must_equal false
      expect(invalid_merchant.errors.messages).must_include :name
    end
  end
  
  describe "relations" do
    it "can have one or many products" do
      merchant.must_respond_to :products
      merchant.products.each do |product|
        product.must_be_kind_of Product
      end
    end
    
  end
  
  describe "custom methods" do
    describe "total_revenue" do
      it "calculates the total revenue" do
        expect(merchants(:besalu).total_revenue).must_equal 44.4
      end
      
      it "returns 0 if the merchant has made no sales" do
        expect(merchants(:nouveau).total_revenue).must_equal 0
      end
    end
    
    describe "revenue_by_status" do
      it "calculates the total revenue by status passed in" do
        expect(merchants(:besalu).revenue_by_status("paid")).must_equal 44.4
        expect(merchants(:sea_wolf).revenue_by_status("pending")).must_equal 115.75
      end
      
      it "will return 0 for a non-existing status" do
        expect(merchants(:besalu).revenue_by_status("ya")).must_equal 0.0
      end
    end
    
    describe "num_orders" do
      it "calculates the total amount of order items for a certain status" do
        expect(merchants(:besalu).num_orders("paid")).must_equal 2
      end
      
      it "will return 0 if there are no order items" do
        expect(merchants(:nouveau).num_orders("paid")).must_equal 0
      end
      
    end
  end
  
end
