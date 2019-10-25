require "test_helper"

describe CategoriesController do
  let (:existing_category) { categories(:started) }
  describe "index" do
    it "succeeds when there are categories" do
      get categories_path
      
      must_respond_with :success
    end
    
    it "succeeds when there are no categories" do
      Category.all do |category|
        category.destroy
      end
      
      get categories_path
      
      must_respond_with :success
    end
  end
  
  describe "show" do
    it "succeeds for an existing category" do
      get category_path(existing_category)
      
      must_respond_with :success
    end
    
    it "renders 404 if the category doesn't exist" do
      destroyed_id = existing_category.id
      existing_category.destroy
      
      get category_path(destroyed_id)
      must_respond_with :not_found
    end
  end
  
  describe "new" do
    it "succeeds" do
      get new_category_path
      
      must_respond_with :success
    end
  end
  
  describe "create" do
    it "creates a category with valid data" do
      new_category = { category: {name: "test name"}}
      
      expect {post categories_path, params: new_category}.must_change "Category.count", 1
      
      category = Category.find_by(name: "test name")
      
      must_respond_with :redirect
      expect(category.name).must_equal new_category[:category][:name]
      must_redirect_to categories_path
    end
    
    it "renders bad_request and does not update the DB for bogus data" do
      bad_category = { category: {name: nil}}
      
      expect {post categories_path, params: bad_category }.wont_change "Category.count"
      
      must_respond_with :bad_request
    end
  end
end
