require "test_helper"

describe ReviewsController do
  
  describe "logged in users" do
    before do
      perform_login
    end
    
    let (:existing_review) { review(:started) }
    
    describe "new" do
      it "succeeds" do
        get new_product_review_path(Product.first.id)
        
        must_respond_with :success
      end
      
      it "does not allow merchant to review product if product is merchant's" do 
        product = Product.first
        merchant = Merchant.find(product.merchant_id)
        
        # TODO: Unsure how to modify @current_merchant in reviews_controller.rb for check_authorization() method
        
        get new_product_review_path(product.first)
        must_respond_with :success
        expect (flash[:result_text]).must_equal "You may not review your own product."
      end
    end
    
    describe "create" do
      it "creates a review with valid data" do
        product = Product.first.id
        new_review = { review: {text: "test name", rating: 1, product_id: product}}
        # binding.pry
        expect {post product_reviews_path(product), params: new_review}.must_change "Review.count", 1
        
        review = Review.find_by(text: "test name")
        
        must_respond_with :redirect
        expect(review.text).must_equal new_review[:review][:text]
        must_redirect_to product_path(product)
      end
      
      it "renders bad_request and does not update the DB for bogus data" do
        product = Product.first
        bad_review = { review: {text: nil, rating: nil, product_id: product.id}}
        
        expect {post product_reviews_path(product), params: bad_review }.wont_change "Review.count"
        
        must_respond_with :bad_request
        expect (flash[:result_text]).must_equal "Unable to save review for #{product.name}."
        
      end
    end
    
  end
  
  describe "guest users" do
    let (:existing_review) { reviews(:one) }
    
    describe "new" do
      it "will allow a guest to go through" do
        get new_product_review_path(Product.first.id)
        
        must_respond_with :success
      end
    end
  end
  
end
