class DashboardController < ApplicationController
  before_action :require_login

  def index
    @user = current_user

    @created_trips = @user.created_trips.count
    @joined_trips = @user.trips.count
    @total_trips = @user.trips.count

    @active_trips = @user.trips
                         .where("end_date >= ?", Date.today)
                         .count

    @completed_trips = @user.trips
                            .where("end_date < ?", Date.today)
                            .count

    @total_members = Membership
                       .where(trip_id: @user.trip_ids)
                       .count

    @expenses = Expense.where(trip_id: @user.trip_ids)

    @total_expenses = @expenses.sum(:amount)

    @total_paid = @expenses
                    .where(payer: @user)
                    .sum(:amount)

    # -------------------------
    # Category Analytics
    # -------------------------
    @category_expenses = @expenses.group(:category).sum(:amount)
    @category_total = @category_expenses.values.sum

    @recent_trips = @user.trips
                         .order(created_at: :desc)
                         .limit(5)

    @recent_expenses = @expenses
                         .includes(:trip)
                         .order(created_at: :desc)
                         .limit(5)

    @upcoming_trips = @user.trips
                           .where("start_date > ?", Date.today)
                           .order(:start_date)
                           .limit(5)

    # -------------------------
    # Balance Summary
    # -------------------------
    @you_receive = 0
    @you_owe = 0

    @user.trips.each do |trip|
      balance = BalanceCalculator.new(trip).balances[@user]
      next unless balance

      if balance[:balance] > 0
        @you_receive += balance[:balance]
      elsif balance[:balance] < 0
        @you_owe += balance[:balance].abs
      end
    end

    # -------------------------
    # Monthly Analytics
    # -------------------------
    @monthly_expenses = @expenses.group_by do |expense|
      expense.spent_on.strftime("%b %Y")
    end

    @monthly_labels = @monthly_expenses.keys

    @monthly_totals = @monthly_expenses.values.map do |items|
      items.sum(&:amount)
    end

    # -------------------------
    # Member Contribution
    # -------------------------
    @member_contributions = []

    @user.trips.each do |trip|
      trip.users.each do |member|
        paid = trip.expenses.where(payer: member).sum(:amount)

        existing = @member_contributions.find do |item|
          item[:user] == member
        end

        if existing
          existing[:amount] += paid
        else
          @member_contributions << {
            user: member,
            amount: paid
          }
        end
      end
    end

    @total_contribution =
      @member_contributions.sum { |m| m[:amount] }

    @highest_contributor =
      @member_contributions.max_by { |m| m[:amount] }

    @lowest_contributor =
      @member_contributions.min_by { |m| m[:amount] }

    # -------------------------
    # Settlement Analytics
    # -------------------------
    @pending_settlements = Settlement.where(
      trip_id: @user.trip_ids,
      status: :pending
    )

    @completed_settlements = Settlement.where(
      trip_id: @user.trip_ids,
      status: :completed
    )

    @pending_count = @pending_settlements.count

    @completed_count = @completed_settlements.count

    @total_settlement_amount =
      Settlement.where(trip_id: @user.trip_ids).sum(:amount)

    @completed_amount =
      @completed_settlements.sum(:amount)

    @pending_amount =
      @pending_settlements.sum(:amount)

    @settlement_completion =
      if @total_settlement_amount.zero?
        0
      else
        ((@completed_amount / @total_settlement_amount.to_f) * 100).round(1)
      end
  end
end