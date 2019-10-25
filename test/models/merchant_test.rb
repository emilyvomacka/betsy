require "test_helper"

describe Merchant do
  describe "relations" do
    let (:merchant) {merchants(:nouveau)}
    
    it "can have one or many products" do
      merchant.must_respond_to :products
      merchant.products.each do |product|
        product.must_be_kind_of Product
      end
    end
    
  end
end
