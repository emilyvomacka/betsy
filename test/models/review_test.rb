require "test_helper"

describe Review do
  let (:review) {reviews(:one)}
  
  describe "validations" do
    it "is valid with all fields present" do
      result = review.valid?
      expect(result).must_equal true
    end
    
    it  "is invalid without a rating" do
      review.rating = nil
      _(result = review.valid?).must_equal false
      expect(review.errors.messages).must_include :rating
    end
    
    it  "is invalid without text" do
      review.text = nil
      _(result = review.valid?).must_equal false
      expect(review.errors.messages).must_include :text
    end
    
    it "is invalid with a rating that is not 1-5" do
      review.rating = 0
      _(result = review.valid?).must_equal false
      expect(review.errors.messages).must_include :rating
      
      review.rating = 6
      _(result = review.valid?).must_equal false
      expect(review.errors.messages).must_include :rating
      
      review.rating = 101
      _(result = review.valid?).must_equal false
      expect(review.errors.messages).must_include :rating
    end
  end
  
  describe "relations" do
    it "belongs to a product" do
    end
  end
end
