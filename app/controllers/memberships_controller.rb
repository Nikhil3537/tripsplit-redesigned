class MembershipsController < ApplicationController
  before_action :require_login
  before_action :set_trip

  def create
    user = User.find(params[:user_id])

    Membership.find_or_create_by!(
      trip: @trip,
      user: user
    ) do |membership|
      membership.role = "member"
    end

    redirect_to @trip, notice: "Member added successfully."
  end

  def destroy
    membership = @trip.memberships.find(params[:id])

    if membership.role == "owner"
      redirect_to @trip, alert: "Owner cannot be removed."
    else
      membership.destroy
      redirect_to @trip, notice: "Member removed successfully."
    end
  end

  private

  def set_trip
    @trip = Trip.find(params[:trip_id])
  end
end