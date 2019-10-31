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
  
  def create
    auth_hash = request.env["omniauth.auth"]
    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
    if merchant
      flash[:success] = "Logged in as returning Merchant #{merchant.name}"
    else
      merchant = Merchant.build_from_github(auth_hash)
      
      if merchant.save
        flash[:success] = "Logged in as new merchant #{merchant.name}"
      else
        flash[:error] = "Could not create new merchant account: #{merchant.errors.messages}"
        return redirect_to root_path
      end
    end
    
    session[:merchant_id] = merchant.id
    session[:merchant_name] = merchant.name
    redirect_to root_path
    return
  end
  
  def destroy
    if @current_merchant != nil
      session[:merchant_id] = nil
      session[:merchant_name] = nil
      flash[:status] = :success
      flash[:result_text] = "Successfully logged out!"
    else
      flash[:status] = :danger
      flash[:result_text] = "You are not logged in."
    end
    
    redirect_to root_path
    return
  end
  
  def dashboard
    if session[:merchant_id] == params[:id].to_i
      @merchant = Merchant.find_by(id: params[:id])
    else
      flash[:status] = :danger
      flash[:result_text] = "You are not authorized to view this page."
      render 'products/main', status: :unauthorized 
      return
    end
  end
end






