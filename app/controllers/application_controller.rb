class ApplicationController < ActionController::Base
  before_action :current_merchant
  
  def current_merchant
    @current_merchant = Merchant.find_by(id: session[:merchant_id])
  end
  
  def require_login
    if @current_merchant.nil?
      flash[:status] = :failure
      flash[:result_text] = "You must be logged in to view this page."
      redirect_back fallback_location: root_path
      return
    end
  end
end
