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
end
