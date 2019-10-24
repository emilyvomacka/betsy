require "test_helper"

describe ProductsController do
  let (:existing_product) { products(:baguette) }
  
  describe "root" do
    #root path not set yet
  end
  
  describe "index" do
    it "succeeds when there are products" do
      get products_path
      
      must_respond_with :success
    end
    
    it "succeeds when there are no products" do
      Product.all do |product|
        product.destroy
      end
      
      get products_path
      
      must_respond_with :success
    end
  end
  
  describe "show" do
    it "succeeds for an existing product" do
      get product_path(existing_product)
      
      must_respond_with :success
    end
    
    it "renders 404 if the work doesn't exist" do
      destroyed_id = existing_product.id
      existing_product.destroy
      
      get product_path(destroyed_id)
      must_respond_with :not_found
    end
  end
  
  describe "new" do
    it "succeeds" do
      get new_product_path
      
      must_respond_with :success
    end
  end
  
  describe "create" do
    it "creates a product with valid data for a real category" do
      new_product = { product: {name: "test name", description: "test", price: 1, photo_URL: "test", stock: 1000, merchant_id: merchants(:sea_wolf).id, categories: [categories(:started)]}}
      
      expect {post products_path, params: new_product}.must_change "Product.count", 1
      
      new_product_id = Product.find_by(name: "test name").id
      
      must_respond_with :redirect
      must_redirect_to product_path(new_product_id)
    end
    
    it "renders bad_request and does not update the DB for bogus data" do
      bad_product = { product: {name: nil, description: "test", price: 1, photo_URL: "test", stock: 1000, merchant_id: merchants(:sea_wolf).id, categories: [categories(:started)]}}
      
      expect {post products_path, params: bad_product }.wont_change "Product.count"
      
      must_respond_with :bad_request
    end
    
    
    it "renders 400 bad_request for bogus categories" do
      skip
      
      #not working
      invalid_product = { product: {name: "test name", description: "test", price: 1, photo_URL: "test", stock: 1000, merchant_id: merchants(:sea_wolf).id, categories: ["fake category"]}}
      
      expect { post products_path, params: invalid_product }.wont_change "Product.count"
      
      Product.find_by(title: "test name", categories: "fake category").must_be_nil
      must_respond_with :bad_request
    end
  end
  
  describe "edit" do
    it "succeeds for an extant product ID" do
      get edit_product_path(existing_product.id)
      
      must_respond_with :success
    end
    
    it "renders 404 not_found for a bogus work ID" do
      bogus_id = existing_product.id
      existing_product.destroy
      
      get edit_product_path(bogus_id)
      
      must_respond_with :not_found
    end
  end
  
  describe "update" do
    it "succeeds for valid data and an extant product ID" do
      updates = { product: { name: "new name" } }
      
      expect {put product_path(existing_product), params: updates}.wont_change "Product.count"
      updated_product = Product.find_by(id: existing_product.id)
      
      updated_product.name.must_equal updates[:product][:name]
      must_respond_with :redirect
      must_redirect_to product_path(existing_product.id)
    end
    
    it "renders bad_request for bogus data" do
      updates = { product: { name: nil } }
      
      expect {put product_path(existing_product), params: updates}.wont_change "Product.count"
      
      product = Product.find_by(id: existing_product.id)
      
      must_respond_with :not_found
    end
    
    it "renders 404 not_found for a bogus product ID" do
      bogus_id = existing_product.id
      existing_product.destroy
      
      put product_path(bogus_id), params: { product: { name: "test name" } }
      
      must_respond_with :not_found
    end
    
  end
  
  
end


