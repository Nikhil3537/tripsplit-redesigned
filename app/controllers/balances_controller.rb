class BalancesController < ApplicationController
  before_action :require_login

  def index
    @trip = Trip.find(params[:trip_id])
    @balances = BalanceCalculator.new(@trip).balances
  end
end