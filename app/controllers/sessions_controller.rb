class SessionsController < ApplicationController
  skip_before_action :find_user

  def create
    auth_hash = request.env['omniauth.auth']
    @user = User.find_by(uid: auth_hash['uid'], provider:
    auth_hash['provider'])

    if @user
      session[:user_id] = @user.id
      flash[:status] = :success
      flash[:result_text] = "Welcome back, #{@user.username}!"
    else
      @user = User.new(
      uid: auth_hash["uid"],
      provider: auth_hash['provider'],
      username: auth_hash['info']['nickname'],
      email: auth_hash['info']['email'])
      if @user.save
        session[:user_id] = @user.id
        flash[:status] = :success
        flash[:result_text] = "Welcome, #{@user.username}!"
      else
        flash[:status] = :failure
        flash[:result_text] = "Unable to save user!"
        flash[:messages] = @user.errors.messages
      end
    end
    redirect_to root_path
  end


  def login_form
  end

  def login
    username = params[:username]
    if username and user = User.find_by(user: username)
      session[:user_id] = user.id
      flash[:status] = :success
      flash[:result_text] = "Successfully logged in as existing user #{user.username}"
    else
      user = User.new(username: username)
      if user.save
        session[:user_id] = user.id
        flash[:status] = :success
        flash[:result_text] = "Successfully created new user #{user.username} with ID #{user.id}"
      else
        flash.now[:status] = :failure
        flash.now[:result_text] = "Could not log in"
        flash.now[:messages] = user.errors.messages
        render "login_form", status: :bad_request
        return
      end
    end
    redirect_to root_path
  end

  def logout
    # @auth_hash = nil
    session[:user_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out"
    redirect_to root_path
  end


end
