class ReviewsController < ApplicationController 
  
  def new
    @review = Review.new
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
