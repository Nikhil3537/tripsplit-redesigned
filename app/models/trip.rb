class Trip < ApplicationRecord
  belongs_to :creator, class_name: "User"

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :join_requests, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :settlements, dependent: :destroy

  before_create :generate_join_token
  after_create :add_creator_as_owner

  validates :name, presence: true

  enum :status, {
  active: 0,
  ended: 1,
  closed: 2
}

  private

  def generate_join_token
    self.join_token ||= SecureRandom.hex(10)
  end

  def add_creator_as_owner
    memberships.create!(
      user: creator,
      role: "owner"
    )
  end
end