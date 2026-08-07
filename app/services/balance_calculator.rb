class BalanceCalculator
  def initialize(trip)
    @trip = trip
  end

  def balances
    result = {}

    @trip.users.each do |user|
      paid = completed_expenses
               .where(payer: user)
               .sum(:amount)

      share = user.expense_splits
                  .joins(:expense)
                  .where(expenses: { trip_id: @trip.id })
                  .sum(:amount)

      result[user] = {
        paid: paid,
        share: share,
        balance: paid - share
      }
    end

    result
  end

  private

  def completed_expenses
    @trip.expenses
         .joins(:expense_splits)
         .distinct
  end
end