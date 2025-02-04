class CategoriesController < ApplicationController
  before_action :require_login, except: [:index, :show]
  
  def index
    @categories = Category.all
  end
  
  def show
    @category = Category.find_by(id: params[:id])
    
    if @category.nil?
      head :not_found
      return
    end
  end
  
  def new 
    @category = Category.new
  end
  
  def create
    @category = Category.new(category_params)
    
    if @category.save
      flash[:status] = :success
      flash[:success] = "Successfully created category #{@category.name}."
      redirect_to categories_path
    else
      flash.now[:status] = :failure
      flash.now[:error] = "Unable to create category #{@category.name}."
      render :new, status: :bad_request
    end
  end
  
  private
  
  def category_params
    return params.require(:category).permit(:name)
  end
  
end
