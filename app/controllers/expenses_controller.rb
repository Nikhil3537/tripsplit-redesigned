class ExpensesController < ApplicationController
  before_action :require_login
  before_action :set_trip
  before_action :require_membership
  before_action :set_expense, only: [:show, :edit, :update, :destroy]

  def index
    @expenses = @trip.expenses.order(spent_on: :desc)
  end

  def new
    @expense = @trip.expenses.new
  end

  def create
    @expense = @trip.expenses.new(expense_params)
    @expense.payer = current_user

    user_ids = params[:expense][:user_ids]&.reject(&:blank?) || []

    if user_ids.empty?
      flash.now[:alert] = "Please select at least one member."
      render :new, status: :unprocessable_entity
      return
    end

    if @expense.save
      share = @expense.amount / user_ids.count

      user_ids.each do |user_id|
        @expense.expense_splits.create!(
          user_id: user_id,
          amount: share
        )
      end

      redirect_to trip_path(@trip), notice: "Expense added successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @expense.update(expense_params)
      redirect_to trip_expenses_path(@trip), notice: "Expense updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    redirect_to trip_expenses_path(@trip), notice: "Expense deleted."
  end

  private

  def set_trip
    @trip = Trip.find(params[:trip_id])
  end

  def require_membership
    unless @trip.users.include?(current_user)
      redirect_to trips_path, alert: "You are not a member of this trip."
    end
  end

  def set_expense
    @expense = @trip.expenses.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(
      :title,
      :amount,
      :category,
      :description,
      :spent_on
    )
  end
end