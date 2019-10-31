require "test_helper"

describe Merchant do
  let (:merchant) {merchants(:nouveau)}
  
  describe "validations" do
    
    it "is valid with all fields present and valid" do
      expect(merchant.valid?).must_equal true
    end
    
    it "is invalid without a nickname" do
      merchant.nickname = nil
      
      expect(merchant.valid?).must_equal false
      expect(merchant.errors.messages).must_include :nickname
    end
    
    it 'is invalid without a unique nickname' do
      invalid_merchant = Merchant.create(nickname: "wolfy", email: "new email")
      
      expect(invalid_merchant.valid?).must_equal false
      expect(invalid_merchant.errors.messages).must_include :nickname
    end
    
    it 'is invalid without an email address' do
      merchant.email = nil
      
      expect(merchant.valid?).must_equal false
      expect(merchant.errors.messages).must_include :email
    end
    
    it 'is invalid without a unique email address' do
      invalid_merchant = Merchant.create(name: "new merchant", email: "seawolf@bakers.com")
      
      expect(invalid_merchant.valid?).must_equal false
      expect(invalid_merchant.errors.messages).must_include :email
    end
  end
  
  describe "relations" do
    it "can have one or many products" do
      _(merchant).must_respond_to :products
      merchant.products.each do |product|
        product.must_be_kind_of Product
      end
    end
    
    it "can have one or more order items through products" do
      _(merchant).must_respond_to :order_items
      merchant.order_items.each do |order_item|
        order_item.must_be_kind_of OrderItem
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
    
    
    describe "build_from_github" do
      it "returns a merchant" do
        auth_hash = OmniAuth::AuthHash.new(mock_auth_hash(merchants(:besalu)))
        
        merchant = Merchant.build_from_github(auth_hash)
        
        merchant.must_be_kind_of Merchant
        expect(merchant.uid).must_equal auth_hash[:uid]
        expect(merchant.provider).must_equal "github"
        expect(merchant.email).must_equal auth_hash["info"]["email"]
        expect(merchant.nickname).must_equal auth_hash["info"]["nickname"]
        expect(merchant.name).must_equal auth_hash["info"]["name"]
      end
    end
  end
  
end