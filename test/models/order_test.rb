require "test_helper"

describe Order do
  let(:existing_order) { orders(:a) }
  
  describe "relationships" do 
    it "has many order items" do 
      expect(existing_order).must_respond_to :order_items
    end
  end
  
  describe 'validations' do
    before do
      @new_order = Order.new(cart_status: "pending")
      @update_params = { 
        customer_name: "Sea Wolf",
        email_address: "sea@wolf.com",
        mailing_address: "22nd St",
        cc_number: 1111111111111111,
        cc_expiration: 12/22,
        cc_security_code: 111,
        zip_code: 12345 }
      end
      
      it 'is valid when created with cart status present' do
        expect(@new_order.valid?).must_equal true
        puts @new_order.errors.any?
      end
      
      it 'is (invalid upon creation without a cart status' do
        @new_order.cart_status = nil
        expect(@new_order.valid?).must_equal false
        expect(@new_order.errors.messages).must_include :cart_status
      end
      
      it 'is valid upon update when all fields are properly entered' do 
        @new_order.update(@update_params)
        expect(@new_order.valid?).must_equal true 
      end 
      
      it "is invalid upon update without customer_name" do 
        @update_params[:customer_name] = nil
        @new_order.update(@update_params)
        expect(@new_order.valid?).must_equal false
        expect(@new_order.errors.messages).must_include :customer_name
      end 
      
      it "is invalid upon update without mailing_address" do 
        @update_params[:mailing_address] = nil
        @new_order.update(@update_params)
        expect(@new_order.valid?).must_equal false
        expect(@new_order.errors.messages).must_include :mailing_address
      end 
      
      it "is invalid upon update without email_address" do 
        @update_params[:email_address] = nil
        @new_order.update(@update_params)
        expect(@new_order.valid?).must_equal false
        expect(@new_order.errors.messages).must_include :email_address
      end 
      
      it "is invalid upon update without cc_number" do 
        @update_params[:cc_number] = nil
        @new_order.update(@update_params)
        expect(@new_order.valid?).must_equal false
        expect(@new_order.errors.messages).must_include :cc_number
      end 
      
      it "is invalid upon update without cc_number" do 
        @update_params[:cc_number] = nil
        @new_order.update(@update_params)
        expect(@new_order.valid?).must_equal false
        expect(@new_order.errors.messages).must_include :cc_number
      end 
      
      it "is invalid upon update without cc_expiration" do 
        @update_params[:cc_expiration] = nil
        @new_order.update(@update_params)
        expect(@new_order.valid?).must_equal false
        expect(@new_order.errors.messages).must_include :cc_expiration
      end 
      
      it "is invalid upon update without cc_security_code" do 
        @update_params[:cc_security_code] = nil
        @new_order.update(@update_params)
        expect(@new_order.valid?).must_equal false
        expect(@new_order.errors.messages).must_include :cc_security_code
      end 
      
      it "is invalid upon update without zip_code" do 
        @update_params[:zip_code] = nil
        @new_order.update(@update_params)
        expect(@new_order.valid?).must_equal false
        expect(@new_order.errors.messages).must_include :zip_code
      end 
      
      it "is invalid upon update without cc_expiration" do 
        @update_params[:cc_expiration] = nil
        @new_order.update(@update_params)
        expect(@new_order.valid?).must_equal false
        expect(@new_order.errors.messages).must_include :cc_expiration
      end 
      
      it "validates that length of cc_number is 16 upon update" do
        @update_params[:cc_number] = 111111
        @new_order.update(@update_params)
        expect(@new_order.valid?).must_equal false
        expect(@new_order.errors.messages).must_include :cc_number
        @update_params[:cc_number] = 11111111111111111111111111
        @new_order.update(@update_params)
        expect(@new_order.valid?).must_equal false
        expect(@new_order.errors.messages).must_include :cc_number
      end 
      
      it "validates that length of cc_security_code is 3 upon update" do
        @update_params[:cc_security_code] = 1
        @new_order.update(@update_params)
        expect(@new_order.valid?).must_equal false
        expect(@new_order.errors.messages).must_include :cc_security_code
        @update_params[:cc_number] = 11111111111111111111111111
        @new_order.update(@update_params)
        expect(@new_order.valid?).must_equal false
        expect(@new_order.errors.messages).must_include :cc_security_code
      end 
      
      it "validates that length of zip_code is 5 upon update" do
        @update_params[:zip_code] = 1
        @new_order.update(@update_params)
        expect(@new_order.valid?).must_equal false
        expect(@new_order.errors.messages).must_include :zip_code
        @update_params[:zip_code] = 11111111111111111111111111
        @new_order.update(@update_params)
        expect(@new_order.valid?).must_equal false
        expect(@new_order.errors.messages).must_include :zip_code
      end 
    end 
    
    describe "custom methods" do
      describe "total_cost" do
        it "adds up total costs of an order" do 
          expect(existing_order.total_cost).must_equal 0.11575e3
        end 
        
        it "calculates a new total when additional items are added to an order" do
          new_item = OrderItem.new(quantity: 1, product: products(:baguette), order: existing_order)
          existing_order.order_items << new_item 
          expect(existing_order.total_cost).must_equal 0.1197e3
        end 
        
        it "returns 0 when there are no order items" do
          existing_order.order_items.destroy_all
          expect(existing_order.total_cost).must_equal 0
        end 
      end 
      
      describe "consolidate order items" do
        it "returns false when a new order item does not share a product id with existing order items" do
          expect(existing_order.consolidate_order_items(products(:seedy).id, 1)).must_equal false 
        end 
        
        it "returns true when a new order item shares a product id with existing order items, and +='s the existing order item's quantity accordingly" do 
          expect(existing_order.consolidate_order_items(products(:daily_baguette).id, 1)).must_equal true
          expect(order_items(:one).quantity).must_equal 2
        end 
        
        it "returns false when an order has no existing items" do 
          existing_order.order_items.destroy_all
          expect(existing_order.consolidate_order_items(products(:daily_baguette).id, 1)).must_equal false 
        end
      end 
      
      describe "return merchant items" do
        it "returns an array of all merchant items from an order" do 
          expect(existing_order.return_merchant_items(merchants(:sea_wolf).id)).must_equal [order_items(:one), order_items(:two)]
        end 
        
        it "returns an empty array when merchant has no items in an order" do
          expect(existing_order.return_merchant_items(merchants(:besalu).id)).must_be_empty
        end 
      end 
      
      describe "return merchants" do
        it "returns an array of all merchants involved in a given order" do
          expect(existing_order.return_merchants).must_equal [merchants(:sea_wolf)]
        end 
        
        it "returns an empty array when an order has no order items" do 
          existing_order.order_items.destroy_all
          expect(existing_order.return_merchants).must_be_empty
        end 
      end 
      
      describe "existing quantity" do
        it "return the quantity of a product currently existing in an order" do
          expect(existing_order.existing_quantity(products(:baguette).id)).must_equal 4
        end 
        it "returns 0 when an order does not contain the given product" do
          expect(existing_order.existing_quantity(products(:seedy).id)).must_equal 0
        end 
      end
    end 
  end 