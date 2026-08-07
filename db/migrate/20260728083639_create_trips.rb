class CreateTrips < ActiveRecord::Migration[8.1]
  def change
    create_table :trips do |t|
      t.string :name
      t.string :destination
      t.date :start_date
      t.date :end_date
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.string :join_token

      t.timestamps
    end
  end
end
