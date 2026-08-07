class JoinRequest < ApplicationRecord
  belongs_to :user
  belongs_to :trip

  enum :status, {
    pending: 0,
    accepted: 1,
    rejected: 2
  }

  validates :user_id,
            uniqueness: {
              scope: :trip_id,
              message: "already requested to join this trip"
            }

  validate :user_not_already_member, on: :create

  private

  def user_not_already_member
    if trip.users.include?(user)
      errors.add(:base, "You are already a member of this trip.")
    end
  end
end