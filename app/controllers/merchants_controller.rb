class MerchantsController < ApplicationController
  
  def index
    @merchants = Merchant.all
  end
  
  def show 
    @merchant = Merchant.find_by(id: params[:id])
    
    if @merchant.nil?
      head :not_found
      return
    end
  end
  
  def login
  end
  
  def logout
  end
  
  # def dashboard
  #   @merchant =  Merchant.find_by(id: params[:id])
  # end
  
  
  
end
