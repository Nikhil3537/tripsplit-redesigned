class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id

      puts "join_token param = #{params[:join_token].inspect}"
      puts "join_token session = #{session[:join_token].inspect}"

      if params[:join_token].present?
        redirect_to join_trip_path(token: params[:join_token]), notice: "Logged in successfully."
      elsif session[:join_token].present?
        token = session.delete(:join_token)
        redirect_to join_trip_path(token: token), notice: "Logged in successfully."
      else
        redirect_to trips_path, notice: "Logged in successfully."
      end
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to new_session_path, notice: "Logged out successfully."
  end
end