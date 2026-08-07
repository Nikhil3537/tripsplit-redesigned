class AddJoinTokenToTrips < ActiveRecord::Migration[8.1]
  def change
    add_column :trips, :join_token, :string
  end
end


