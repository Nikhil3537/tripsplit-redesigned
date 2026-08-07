class TripsController < ApplicationController
  before_action :require_login
  before_action :set_trip, only: [
    :show,
    :edit,
    :update,
    :destroy,
    :end_trip,
    :final_settlement
  ]

  def index
    @trips = current_user.trips
  end

  def show
  end

  def new
    @trip = Trip.new
  end

  def create
    @trip = current_user.created_trips.build(trip_params)

    if @trip.save
      redirect_to @trip, notice: "Trip created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @trip.update(trip_params)
      redirect_to @trip, notice: "Trip updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @trip.destroy
    redirect_to trips_path, notice: "Trip deleted successfully."
  end
  def end_trip
    @trip = Trip.find(params[:id])

    @trip.update(status: :ended)

    SettlementGenerator.new(@trip).generate

    redirect_to final_settlement_trip_path(@trip),
              notice: "Trip ended successfully."
  end
  def final_settlement
    @trip = Trip.find(params[:id])

    unless @trip.users.include?(current_user)
      redirect_to trips_path,
                alert: "You are not authorized to view this trip."
    end
  end

  private

  def set_trip
    @trip = Trip.find(params[:id])

    unless @trip.users.include?(current_user)
      redirect_to trips_path,
                  alert: "You are not a member of this trip."
    end
  end

  def trip_params
    params.require(:trip).permit(
      :name,
      :destination,
      :start_date,
      :end_date
    )
  end
end