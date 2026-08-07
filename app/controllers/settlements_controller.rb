class SettlementsController < ApplicationController
  before_action :require_login
  before_action :set_trip
  before_action :set_settlement, only: [:update]

  def index
    @settlements = @trip.settlements
                        .includes(:payer, :receiver)
                        .order(created_at: :asc)
  end

  def update
    @settlement.completed!

    redirect_to trip_settlements_path(@trip),
                notice: "Settlement marked as completed."
  end

  private

  def set_trip
    @trip = Trip.find(params[:trip_id])
  end

  def set_settlement
    @settlement = @trip.settlements.find(params[:id])
  end
end