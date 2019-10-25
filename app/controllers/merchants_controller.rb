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
      # User was found in the database
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
    redirect_to root_path
  end
  
  def destroy
    session[:merchant_id] = nil
    flash[:success] = "Successfully logged out!"
    
    redirect_to root_path
  end
  
  def login
    username = params[:username]
    if username and merchant = Merchant.find_by(username: username)
      session[:merchant_id] = merchant.id
      flash[:status] = :success
      flash[:result_text] = "Successfully logged in as existing merchant #{merchant.username}"
    else
      merchant = Merchant.new(username: username)
      if merchant.save
        session[:merchant_id] = merchant.id
        flash[:status] = :success
        flash[:result_text] = "Successfully created new merchant #{merchant.username} with ID #{merchant.id}"
      else
        flash.now[:status] = :failure
        flash.now[:result_text] = "Could not log in"
        flash.now[:messages] = merchant.errors.messages
        render "login_form", status: :bad_request
        return
      end
    end
    redirect_to root_path
  end
  
  def logout
    session[:merchant_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out"
    redirect_to root_path
  end
  
  # def dashboard
  #   @merchant =  Merchant.find_by(id: params[:id])
  # end
  
  
  
end
