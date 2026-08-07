class AddStatusToTrips < ActiveRecord::Migration[8.1]
  def change
    add_column :trips, :status, :integer, default: 0
  end
end
