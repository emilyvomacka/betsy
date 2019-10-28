require "test_helper"

describe Review do
  describe "validations" do
    it "is valid with all fields present" do
    end
    
    it "is invalid without a rating" do
    end
    
    it "is invalid without text" do
    end 
    
    it "is invalid with a rating that is not 1-5" do
      #check if rating is 0
      #check if rating is 6
      #check if rating is non-integer, 100, other edge cases
    end
    
  end
  
  describe "relations" do
    it "belongs to a product" do
    end
  end
  
end
