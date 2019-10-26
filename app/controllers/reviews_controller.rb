class ReviewsController < ApplicationController 
  
  def new
    # @review = Review.new
    if params[:product_id]
      product = Product.find_by(id: params[:product_id])
      @review = product.reviews.new 
      
    else
      @review = Review.new
    end
  end
  
  def create
    @review = Review.new(review_params)
    if @review.save
      redirect_to products_path
      return
    else
      render :new
      return
    end
  end
  
  private
  def review_params
    return params.require(:review).permit(:text, :rating, :product_id)
  end
  
end
