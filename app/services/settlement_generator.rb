class SettlementGenerator
  def initialize(trip)
    @trip = trip
  end

  def generate
    return if @trip.settlements.exists?

    balances = BalanceCalculator.new(@trip).balances

    creditors = []
    debtors = []

    balances.each do |user, data|
      if data[:balance] > 0
        creditors << {
          user: user,
          amount: data[:balance].to_f.round(2)
        }
      elsif data[:balance] < 0
        debtors << {
          user: user,
          amount: data[:balance].abs.to_f.round(2)
        }
      end
    end

    creditors.sort_by! { |c| -c[:amount] }
    debtors.sort_by! { |d| -d[:amount] }

    while creditors.any? && debtors.any?
      creditor = creditors.first
      debtor = debtors.first

      amount = [creditor[:amount], debtor[:amount]].min

      Settlement.create!(
        trip: @trip,
        payer: debtor[:user],
        receiver: creditor[:user],
        amount: amount,
        status: :pending
      )

      creditor[:amount] -= amount
      debtor[:amount] -= amount

      creditors.shift if creditor[:amount] <= 0.01
      debtors.shift if debtor[:amount] <= 0.01
    end
  end
end