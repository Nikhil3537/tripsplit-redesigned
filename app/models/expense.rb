class Expense < ApplicationRecord
  belongs_to :trip
  belongs_to :payer, class_name: "User"

  has_many :expense_splits, dependent: :destroy
end