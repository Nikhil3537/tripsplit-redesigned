class JoinRequestsController < ApplicationController
  before_action :require_login, except: [:show]
  before_action :set_trip, only: [:create]
  before_action :set_join_request, only: [:accept, :reject]
  before_action :authorize_owner!, only: [:accept, :reject]

  def show
    @trip = Trip.find_by!(join_token: params[:token])

    unless logged_in?
      session[:join_token] = params[:token]
      redirect_to new_session_path
      return
    end

    @join_request = @trip.join_requests.find_by(user: current_user)
  end

  def create
    if @trip.users.include?(current_user)
      redirect_to join_trip_path(token: @trip.join_token),
                  alert: "You are already a member of this trip."
      return
    end

    @join_request = @trip.join_requests.find_or_initialize_by(user: current_user)
    @join_request.status = :pending

    if @join_request.save
      redirect_to join_trip_path(token: @trip.join_token),
                  notice: "Join request sent successfully."
    else
      redirect_to join_trip_path(token: @trip.join_token),
                  alert: @join_request.errors.full_messages.to_sentence
    end
  end

  def accept
    Membership.find_or_create_by!(
      trip: @join_request.trip,
      user: @join_request.user
    ) do |membership|
      membership.role = "member"
    end

    @join_request.update_column(:status, JoinRequest.statuses[:accepted])

    puts "JoinRequest status: #{@join_request.reload.status}"

    redirect_to trip_path(@join_request.trip),
              notice: "Member added successfully."
  end

  def reject
    @join_request.update_column(:status, JoinRequest.statuses[:rejected])

    puts "JoinRequest status: #{@join_request.reload.status}"

    redirect_to trip_path(@join_request.trip),
              notice: "Request rejected."
  end

  private

  def set_trip
    @trip = Trip.find(params[:trip_id])
  end

  def set_join_request
    @join_request = JoinRequest.find(params[:id])
  end

  def authorize_owner!
    unless @join_request.trip.creator == current_user
      redirect_to trips_path,
                  alert: "You are not authorized."
    end
  end
end