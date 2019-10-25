require "test_helper"

describe Merchant do
  let (:merchant) {merchants(:nouveau)}
  
  describe "validations" do
    
    it "is valid with a username" do
      expect(merchant.valid?).must_equal true
    end
    
    it "is invalid without a username" do
      merchant.username = nil
      
      expect(merchant.valid?).must_equal false
      expect(merchant.errors.messages).must_include :username
    end
    
    it 'is invalid without a unique username' do
      invalid_merchant = Merchant.create(username: "Sea Wolf Bakers")
      
      expect(invalid_merchant.valid?).must_equal false
      expect(invalid_merchant.errors.messages).must_include :username
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
end
