require "test_helper"

describe MerchantsController do
  let (:existing_merchant) { merchants(:macrina) }
  
  describe "index" do
    it "succeeds when there are merchants" do
      get merchants_path
      
      must_respond_with :success
    end
    
    it "succeeds when there are no merchants" do
      Merchant.all do |merchant|
        merchant.destroy
      end
      
      get merchants_path
      
      must_respond_with :success
    end
  end
  
  describe "show" do
    it "succeeds for an existing merchant" do
      get merchant_path(existing_merchant)
      
      must_respond_with :success
    end
    
    it "renders 404 if the merchant doesn't exist" do
      destroyed_id = existing_merchant.id
      existing_merchant.destroy
      
      get merchant_path(destroyed_id)
      must_respond_with :not_found
    end
  end
  
  
  describe "auth_callback" do
    it "logs in an existing merchant and redirects to the root route" do
      start_count = Merchant.count
      
      perform_login(existing_merchant)
      
      must_redirect_to root_path
      
      # Should *not* have created a new merchant
      _(Merchant.count).must_equal start_count
    end
    
    it "creates an account for a new merchant and redirects to the root route" do
      start_count = Merchant.count
      new_merchant = Merchant.new(name: "cafefrance", nickname: "france", email: "cafefrance@gmail.com", uid: 60, provider: "github")
      perform_login(new_merchant)
      
      Merchant.count.must_equal start_count+1
      must_redirect_to root_path
    end
    
    it "redirects to the login route if given invalid merchant data" do
      start_count = Merchant.count
      new_merchant = Merchant.new(name: nil, nickname: nil, email: nil, uid: nil )
      perform_login(new_merchant)
      
      Merchant.count.must_equal start_count 
      must_redirect_to root_path
    end
  end
  
end




