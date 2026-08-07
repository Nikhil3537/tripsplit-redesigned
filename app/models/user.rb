class User < ApplicationRecord
  has_secure_password

  has_many :created_trips,
           class_name: "Trip",
           foreign_key: :creator_id,
           dependent: :destroy

  has_many :memberships, dependent: :destroy
  has_many :trips, through: :memberships

  has_many :join_requests, dependent: :destroy
  has_many :expenses, foreign_key: :payer_id, dependent: :destroy
  has_many :expense_splits, dependent: :destroy
  has_many :payments_made,
         class_name: "Settlement",
         foreign_key: :payer_id,
         dependent: :destroy

  has_many :payments_received,
         class_name: "Settlement",
         foreign_key: :receiver_id,
         dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end