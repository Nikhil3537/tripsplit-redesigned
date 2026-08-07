class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :trip

  validates :role, presence: true

  validates :user_id,
            uniqueness: {
              scope: :trip_id,
              message: "is already a member of this trip"
            }
end