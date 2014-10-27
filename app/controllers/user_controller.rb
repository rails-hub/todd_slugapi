class UserController < ApiController

  skip_before_filter :check_token!

  # username - string
  # password - string
  # email - string
  # phone - string (optional)
  def register_api
    begin
      @user = User.create(register_api_params)
      post @user
    rescue ActiveRecord::RecordNotUnique
      error "The username #{register_api_params[:username].downcase} is taken. Please choose a different one."
    end
  end

  def update_profile
    @find_user = User.find_by_auth_token(params[:auth_token]) unless params[:auth_token].nil?
    if @find_user.nil?
      error "No such user found."
    else
      begin
        @find_user.username = params[:username]
        @find_user.email = params[:email]
        @find_user.phone = params[:phone]
        @find_user.save(:validate => false)
        json @find_user
      rescue ActiveRecord::RecordNotFound
        error "Error updating profile."
      end
    end
  end

  def update_password
    @user = User.find_by_auth_token(params[:auth_token]) unless params[:auth_token].nil?
    if @user.valid_password?(params[:old_password])
      begin
        @user.password = params[:new_password]
        @user.save(:validate => true)
        success "Password Changed Successfully"
      rescue
        error "Something went wrong"
      end
    else
      error "Old Password Doesn't match"
    end
  end

  def admin_log_in
  end

  # username - string (optional)
  # password - string (optional)
  # auth_token - string (optional)
  def login_api
    @user = User.find_for_database_authentication({:username => params[:username].downcase})

    if (!@user.nil?)
      if (!@user.valid_password?(params[:password]))
        @user = nil
      end
    end

    if (@user.nil?)
      @user = User.find_by_auth_token(params[:auth_token]) unless params[:auth_token].nil?
    else
      @user.generate_auth_token
    end

    if @user.nil?
      # Do nothing
      error "Your username or password was incorrect."
    else
      render json: @user
    end
  end

  def update_device_token
    @user = User.find_by_auth_token(params[:auth_token]) unless params[:auth_token].nil?
    if (!@user.nil?)
      begin
        @user.update_attribute('device_token', device_token_api_params[:device_token])
        success "Device Token updated"
      rescue
        error "Something went wrong"
      end
    else
      error "No such user exist"
    end
  end


  def register_api_params
    params.permit(:username, :password, :email, :phone)
  end

  def login_api_params
    params.permit(:username, :password, :auth_token)
  end

  def device_token_api_params
    params.permit(:device_token, :auth_token)
  end

  def profile_api_params
    params.permit(:auth_token, :username, :email, :phone)
  end

end
