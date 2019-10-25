require "test_helper"

describe Category do
  let (:category) {categories(:started)}
  describe "validations" do
    it "is valid with a name" do
      expect(category.valid?).must_equal true
    end
    
    it "is invalid without a name" do
      invalid_category = Category.create(name: nil)
      expect(invalid_category.valid?).must_equal false
    end
  end
  
  describe "relations" do
    describe "relations" do
      
      it "has one or many products" do
        category.must_respond_to :products
        category.products.each do |product|
          product.must_be_kind_of Product
        end
      end
      
    end
  end
end
