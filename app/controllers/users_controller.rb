class UsersController < ApplicationController
  before_action :logged_in?, only: [:show]
    
  def show
    render json: @user
  end
  
  def create
    user = User.new(permit_params)
    if user.valid?
      user.save

      render json: {confirmation: "success!", token: generate_token({user_id: user.id})}
    else
      render json: {error: "Unable to create user", details: user.errors.full_messages, username: user.username}
    end
  end

  def leaderboard
    users = User.all.max_by(10) {|user| user.wins}

    render json: users
  end

  def login
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      render json: {confirmation: "success!", token: generate_token({user_id: user.id}), username: user.username}
    else
      render json: {error: "Unable to login", details: ["User not found: Incorrect username or password"]}
    end
  end
  
  private

  def permit_params
    params.permit(:username, :password)
  end
    
end
