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
    session[:merchant_id] = nil
    session[:merchant_name] = nil
    flash[:status] = :success
    flash[:success] = "Successfully logged out!"
    
    redirect_to root_path
    return
  end
  
  def login
    name = params[:name]
    if name and merchant = Merchant.find_by(name: name)
      session[:merchant_id] = merchant.id
      flash[:status] = :success
      flash[:result_text] = "Successfully logged in as existing merchant #{merchant.name}"
    else
      merchant = Merchant.new(name: name)
      if merchant.save
        session[:merchant_id] = merchant.id
        flash[:status] = :success
        flash[:result_text] = "Successfully created new merchant #{merchant.name} with ID #{merchant.id}"
      else
        flash.now[:status] = :danger
        flash.now[:result_text] = "Could not log in."
        flash.now[:messages] = merchant.errors.messages
        render "login_form", status: :bad_request
        return
      end
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
      redirect_to root_path
      return
    end
  end
end






