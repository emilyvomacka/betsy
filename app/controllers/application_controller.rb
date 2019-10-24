class ApplicationController < ActionController::Base
  before_action :current_merchant
  
  
  def current_merchant
    @current_merchant = Merchant.find_by(id: session[:user_id])
  end
  
  def require_login
    if session[:user_id].nil?
      flash[:error] = "You must be logged in to perform this action."
      redirect_to root_path
    end
  end
end
