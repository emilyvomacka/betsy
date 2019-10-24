class ProductsController < ApplicationController 
  def index
    @products = Product.all
  end
  
  def show
    @product = Product.find_by(id: params[:id])
  end
  
  def create
    @product = Product.new(product_params)
    @product.merchant_id = @current_merchant.id
    
    if @product.save
      flash[:status] = :success
      flash[:success] = "Successfully created product #{@product.name}."
      redirect_to product_path(@product)
    else
      flash[:status] = :failure
      flash[:error] = "Unable to create product #{@product.name}."
      render :new, status: :bad_request
    end
  end
  
  # def edit
  #   require_login
  #   @product = Product.find_by(id: params[:id])
  #   render_404 unless @product
  # end
  
  # def update
  #   require_login
  #   #check if user is authorized
  #   @product.update_attributes(product_params)
  #   if @product.save
  #     flash[:status] = :success
  #     flash[:result_text] = "Successfully updated #{@product.name}."
  #     redirect_to product_path(@product)
  #   else
  #     flash.now[:status] = :failure
  #     flash.now[:result_text] = "Could not update #{@product.name}."
  #     flash.now[:messages] = @product.errors.messages
  #     render :edit, status: :not_found
  #   end
  #       
  # end
  
  # def create_review
  #     
  # end
  
  # def retire
  
  # end
end