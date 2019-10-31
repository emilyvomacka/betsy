require "test_helper"

describe ProductsController do
  let (:existing_product) { products(:baguette) }
  
  describe "logged in users" do
    before do
      @current_merchant = perform_login(merchants(:sea_wolf))
    end
    
    describe "root" do
      it "succeeds with all products" do
        get root_path
        
        must_respond_with :success
      end
      
      it "succeeds when there are no products" do
        Product.all do |product|
          product.destroy
        end
        
        get root_path
        
        must_respond_with :success
      end
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
      
      it "renders 404 if the product doesn't exist" do
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
        new_product_hash = { product: {name: "test name", description: "test", price: 1, photo_URL: "http://www.google.com", stock: 1000, merchant_id: @current_merchant.id}}
        
        expect {post products_path, params: new_product_hash}.must_change "Product.count", 1
        
        new_product = Product.find_by(name: "test name")
        
        must_respond_with :redirect
        expect(new_product.name).must_equal new_product_hash[:product][:name]
        expect(new_product.description).must_equal new_product_hash[:product][:description]
        expect(new_product.price).must_equal new_product_hash[:product][:price]
        expect(new_product.photo_URL).must_equal new_product_hash[:product][:photo_URL]
        expect(new_product.stock).must_equal new_product_hash[:product][:stock]
        expect(new_product.merchant_id).must_equal new_product_hash[:product][:merchant_id]
        must_redirect_to product_path(new_product.id)
      end
      
      it "renders bad_request and does not update the DB for bogus data" do
        bad_product = { product: {name: nil, description: "test", price: 1, photo_URL: "test", stock: 1000, merchant_id: @current_merchant.id, categories: [categories(:started)]}}
        
        expect {post products_path, params: bad_product }.wont_change "Product.count"
        
        must_respond_with :bad_request
      end
    end
    
    describe "edit" do
      it "succeeds for an extant product ID" do
        get edit_product_path(@current_merchant.products.first.id)
        
        must_respond_with :success
      end
      
      it "renders 404 not_found for a bogus work ID" do
        bogus_id = existing_product.id
        existing_product.destroy
        
        get edit_product_path(bogus_id)
        
        must_respond_with :not_found
      end
      
      it "only allows merchants to edit their own products" do 
        get edit_product_path(merchants(:besalu).products.first.id)
        
        must_respond_with :unauthorized
      end
    end
    
    describe "update" do
      it "succeeds for valid data and an extant product ID" do
        updates = { product: { name: "new name" } }
        
        expect {put product_path(existing_product), params: updates}.wont_change "Product.count"
        updated_product = Product.find_by(id: existing_product.id)
        
        _(updated_product.name).must_equal updates[:product][:name]
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
      
      it "only allows merchants to update their own products" do 
        updates = { product: { name: "new name" } }
        
        expect {put product_path(products(:seedy)), params: updates}.wont_change "Product.count"
        
        must_respond_with :unauthorized
      end
      
    end
    
    describe "retire method" do
      describe "allows merchants to retire/reactivate their own products" do
        it "toggles product status from 'active' to 'inactive'" do 
          _(existing_product.active).must_equal true
          post retire_path(existing_product)
          
          existing_product.reload
          
          _(existing_product.active).must_equal false
          
          must_respond_with :redirect
          must_redirect_to product_path(existing_product.id)
        end
        
        it "toggles product status from 'retire' to 'active'" do 
          post retire_path(existing_product)
          post retire_path(existing_product)
          existing_product.reload
          
          _(existing_product.active).must_equal true
          
          must_respond_with :redirect
          must_redirect_to product_path(existing_product.id)
        end
      end
      
      it "does not allow merchants to retire other people's products" do 
        not_my_product = merchants(:besalu).products.first
        
        post retire_path(not_my_product)
        
        must_respond_with :unauthorized
      end
      
      it "gives a bad request for products that don't exist" do
        post retire_path(-1)
        
        must_respond_with :not_found
      end
      
    end
    
  end
  
  describe "guest users" do
    
    describe "root" do
      it "succeeds with all products" do
        get root_path
        
        must_respond_with :success
      end
      
      it "succeeds when there are no products" do
        Product.all do |product|
          product.destroy
        end
        
        get root_path
        
        must_respond_with :success
      end
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
      
      it "renders 404 if the product doesn't exist" do
        destroyed_id = existing_product.id
        existing_product.destroy
        
        get product_path(destroyed_id)
        must_respond_with :not_found
      end
    end
    
    describe "new" do
      it "does not allow a guest to view this page" do
        get new_product_path
        
        must_respond_with :unauthorized
      end
    end
    
    describe "create" do
      it "does not allow a guest to create a product with correct parameters" do
        new_product_hash = { product: {name: "test name", description: "test", price: 1, photo_URL: "test", stock: 1000, merchant_id: merchants(:besalu).id}}
        
        expect {post products_path, params: new_product_hash}.wont_change "Product.count"
        
        new_product = Product.find_by(name: "test name")
        
        must_respond_with :unauthorized
      end
      
      it "renders bad_request and does not update the DB for bogus data" do
        bad_product = { product: {name: nil, description: "test", price: 1, photo_URL: "test", stock: 1000, merchant_id: merchants(:besalu).id, categories: [categories(:started)]}}
        
        expect {post products_path, params: bad_product }.wont_change "Product.count"
        
        must_respond_with :unauthorized
      end
    end
    
    describe "edit" do
      it "does not allow a guest to edit a product" do
        get edit_product_path(merchants(:besalu).products.first.id)
        
        must_respond_with :unauthorized
      end
      
      it "renders 404 not_found for a bogus work ID" do
        bogus_id = existing_product.id
        existing_product.destroy
        
        get edit_product_path(bogus_id)
        
        must_respond_with :not_found
      end
      
    end
    
    describe "update" do
      it "doesn't allow a guest to update a product with valid data and an extant product ID" do
        updates = { product: { name: "new name" } }
        
        expect {put product_path(existing_product), params: updates}.wont_change "Product.count"
        
        must_respond_with :unauthorized
      end
      
      it "renders bad_request for bogus data" do
        updates = { product: { name: nil } }
        
        expect {put product_path(existing_product), params: updates}.wont_change "Product.count"
        
        product = Product.find_by(id: existing_product.id)
        
        must_respond_with :unauthorized
      end
      
      it "renders 404 not_found for a bogus product ID" do
        bogus_id = existing_product.id
        existing_product.destroy
        
        put product_path(bogus_id), params: { product: { name: "test name" } }
        
        must_respond_with :not_found
      end
      
      
    end
    
    describe "retire method" do
      it "doesn't allow guests to retire/reactivate products" do
        post retire_path(existing_product)
        
        must_respond_with :unauthorized
      end
      
    end
    
  end
  
end

