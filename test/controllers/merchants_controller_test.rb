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
    
    it "renders 404 if the work doesn't exist" do
      destroyed_id = existing_merchant.id
      existing_merchant.destroy
      
      get merchant_path(destroyed_id)
      must_respond_with :not_found
    end
  end
  
end
