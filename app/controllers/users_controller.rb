class UsersController < ApplicationController

  def homepage
    @users = User.all
  end

  def new

  end

  def create
    if params[:user][:username].strip == "" || params[:user][:password_digest].strip == ""
      message = "fields cannot be blank"
    else
      if User.find_by(username: params[:user][:username])
        message = "username already in database."
      else
         User.create!(username: params[:user][:username], password_digest: BCrypt::Password.create(params[:user][:password_digest].strip), age: params[:user][:age], email: params[:user][:email])
         redirect_to "/"
         return
      end
    end
    flash[:sign_in_message] = message
    redirect_to :back
  end

  def sign_in_page
  end

  def sign_in
    if params[:user][:username].strip == "" || params[:user][:password_digest].strip == ""
      message = "fields cannot be blank"
    else
      if !User.find_by(username: params[:user][:username])
        message = "username not found."
      else
        @user = User.find_by(username: params[:user][:username])
        decoded_hash = BCrypt::Password.new(@user.password_digest)
        if decoded_hash.is_password?(params[:user][:password_digest]) == false
          message = "Your password's wrong!"
        else
          cookies[:username] = params[:user][:username]
          session[:is_signed_in] = true
          session[:user] = User.find_by(username: params[:user][:username])
          redirect_to "/"
          return
        end
      end
    end
    flash[:sign_in_message] = message
    redirect_to "/"
  end
end
