class ApplicationController < ActionController::API
  def generate_token(payload)
    JWT.encode payload, Rails.application.credentials.token_secret
  end

  def logged_in?
      begin
          token = request.headers["Authorization"].split(" ")[1]
          user_id = JWT.decode(token, Rails.application.credentials.token_secret)[0]["user_id"]
          
          @user = User.find user_id 
      rescue 
          @user = nil 
      end

      render json: {
          error: "Please login", 
          details: "Something went wrong with the session token, please login and try again"
      } unless @user
  end
end
