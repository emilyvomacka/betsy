require "test_helper"

describe Product do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end
  
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
  end 
  
end

