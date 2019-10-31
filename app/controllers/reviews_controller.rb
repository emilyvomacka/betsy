class ReviewsController < ApplicationController 
  
  def new
    if params[:product_id]
      @product = Product.find_by(id: params[:product_id])
      @review = @product.reviews.new 
      
      check_authorization
    else
      @review = Review.new
    end
  end
  
  def create
    @review = Review.new(review_params)
    @product = Product.find_by(id: params[:product_id])
    
    check_authorization
    
    if @review.save
      flash[:status] = :success
      flash[:result_text] = "Successfully reviewed #{@review.product.name}."
      redirect_to product_path(@review.product)
      return
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Unable to save review for #{@product.name}."
      render :new, status: :bad_request
      return
    end
  end
  
  private
  def review_params
    return params.require(:review).permit(:text, :rating, :product_id)
  end
  
  def check_authorization
    if @current_merchant != nil && @product.merchant_id == @current_merchant.id
      flash[:status] = :danger
      flash[:result_text] = "You may not review your own product."
      render 'products/main', status: :unauthorized 
      return
    end
  end
  
end
