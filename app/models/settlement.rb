class Settlement < ApplicationRecord
  belongs_to :trip

  belongs_to :payer,
             class_name: "User"

  belongs_to :receiver,
             class_name: "User"

  enum :status, {
    pending: 0,
    completed: 1
  }

  validates :amount, presence: true
end