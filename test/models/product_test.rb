require "test_helper"

describe Product do
  let (:product) {products(:baguette)}
  describe "relations" do
    
    it "has one or many categories" do
      product.must_respond_to :categories
      product.categories.each do |category|
        category.must_be_kind_of Category
      end
    end
    
    it "can have a single merchant" do
      product.must_respond_to :merchant_id
      product.merchant.must_be_kind_of Merchant
    end
    
  end
  describe "custom methods" do 
    describe "retire method" do
      before do
        @product = Product.create(name:"twice-baked almond croissant", description:"Almond Croissants are day old croissants that are filled and topped with almond paste and sliced almonds", price: 1.99, photo_URL: "https://unsplash.com/photos/5msGxboneMA", stock: 11, merchant_id: 5)
      end
      it "toggled self.active from true to false" do
        @product.active = true
        @product.save
        @product.retire
        expect(@product.active).must_equal false
      end
      it "toggled self.active from false to true" do
        @product.active = false
        @product.save 
        @product.retire
        expect(@product.active).must_equal true
      end
    end
    
    describe "validations" do 
      it "must have a name" do 
        product.name = nil 
        
        expect(product.valid?).must_equal false
        expect(product.errors.messages).must_include :name
        expect(product.errors.messages[:name]).must_equal ["can't be blank"]
      end
      
      it "must have a description" do 
        product.description = nil 
        expect(product.valid?).must_equal false
        expect(product.errors.messages).must_include :description
        expect(product.errors.messages[:description]).must_equal ["can't be blank"]
      end
      
      it "must have a price" do 
        product.price = nil 
        expect(product.valid?).must_equal false 
        expect(product.errors.messages).must_include :price
        expect(product.errors.messages[:price]).must_equal ["can't be blank"]
      end
      
      it "must include photo_URL" do 
        product.photo_URL = nil 
        expect(product.valid?).must_equal false
        expect(product.errors.messages).must_include :photo_URL
        expect(product.errors.messages[:photo_URL]).must_equal ["can't be blank"]
      end
      
      it "must be in stock" do 
        product.stock = nil 
        expect(product.valid?).must_equal false
        expect(product.errors.messages).must_include :stock
        expect(product.errors.messages[:stock]).must_equal ["can't be blank"]
        
      end
      
      it "must have a merchant_id associated" do
        product.merchant_id = nil 
        expect(product.valid?).must_equal false
        expect(product.errors.messages).must_include :merchant_id
        expect(product.errors.messages[:merchant_id]).must_equal ["can't be blank"]
      end
    end
    
  end
end 
