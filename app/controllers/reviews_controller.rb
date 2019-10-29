class ReviewsController < ApplicationController 
  
  def new
    if params[:product_id]
      @product = Product.find_by(id: params[:product_id])
      @review = @product.reviews.new 
    else
      @review = Review.new
    end
  end
  
  def create
    @review = Review.new(review_params)
    @product = Product.find_by(id: params[:product_id])
    
    if @review.save
      flash[:status] = :success
      flash[:result_text] = "Successfully reviewed #{@review.product.name}."
      redirect_to product_path(@review.product)
      return
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Unable to save review for #{@review.product.name}."
      render :new
      return
    end
  end
  
  private
  def review_params
    return params.require(:review).permit(:text, :rating, :product_id)
  end
  
end
