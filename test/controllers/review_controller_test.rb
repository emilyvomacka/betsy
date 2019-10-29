require "test_helper"

describe ReviewsController do
  
  describe "logged in users" do
    before do
      perform_login
    end
    
    let (:existing_review) { review(:started) }
    
    describe "index" do
      it "succeeds when there are reviews" do
        get reviews_path
        
        must_respond_with :success
      end
      
      it "succeeds when there are no reviews" do
        Review.all do |review|
          review.destroy
        end
        
        get reviews_path
        
        must_respond_with :success
      end
    end
    
    describe "show" do
      it "succeeds for an existing review" do
        get review_path(existing_review)
        
        must_respond_with :success
      end
      
      it "renders 404 if the review doesn't exist" do
        destroyed_id = existing_review.id
        existing_review.destroy
        
        get review_path(destroyed_id)
        must_respond_with :not_found
      end
    end
    
    describe "new" do
      it "succeeds" do
        get new_review_path
        
        must_respond_with :success
      end
    end
    
    describe "create" do
      it "creates a review with valid data" do
        new_review = { review: {name: "test name"}}
        
        expect {post reviews_path, params: new_review}.must_change "review.count", 1
        
        review = Review.find_by(name: "test name")
        
        must_respond_with :redirect
        expect(review.name).must_equal new_review[:review][:name]
        must_redirect_to reviews_path
      end
      
      it "renders bad_request and does not update the DB for bogus data" do
        bad_review = { review: {name: nil}}
        
        expect {post reviews_path, params: bad_review }.wont_change "review.count"
        
        must_respond_with :bad_request
      end
    end
    
  end
  
  describe "guest users" do
    let (:existing_review) { reviews(:started) }
    
    describe "index" do
      it "succeeds when there are reviews" do
        get reviews_path
        
        must_respond_with :success
      end
      
      it "succeeds when there are no reviews" do
        Review.all do |review|
          review.destroy
        end
        
        get reviews_path
        
        must_respond_with :success
      end
    end
    
    describe "show" do
      it "succeeds for an existing review" do
        get review_path(existing_review)
        
        must_respond_with :success
      end
      
      it "renders 404 if the review doesn't exist" do
        destroyed_id = existing_review.id
        existing_review.destroy
        
        get review_path(destroyed_id)
        must_respond_with :not_found
      end
    end
    
    describe "new" do
      it "will allow a guest to go through" do
        get new_review_path
        
        must_respond_with :redirect
        flash[:result_text].must_equal "You must be logged in to view this page."
      end
    end
    
    describe "create" do
      it "will not creates a review with valid data" do
        new_review = { review: {name: "test name"}}
        
        expect {post reviews_path, params: new_review}.wont_change "review.count"
        
        review = review.find_by(name: "test name")
        
        must_respond_with :redirect
        flash[:result_text].must_equal "You must be logged in to view this page."
      end
      
      it "will not update the DB for bogus data and redirect" do
        bad_review = { review: {name: nil}}
        
        expect {post reviews_path, params: bad_review }.wont_change "review.count"
        
        must_respond_with :redirect
        flash[:result_text].must_equal "You must be logged in to view this page."
      end
    end
  end
  
end
