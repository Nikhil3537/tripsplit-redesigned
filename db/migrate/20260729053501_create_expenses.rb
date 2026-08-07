class CreateExpenses < ActiveRecord::Migration[8.1]
  def change
    create_table :expenses do |t|
      t.references :trip, null: false, foreign_key: true

      t.references :payer,
                   null: false,
                   foreign_key: { to_table: :users }

      t.string :title
      t.decimal :amount, precision: 10, scale: 2

      t.string :category

      t.text :description

      t.date :spent_on

      t.timestamps
    end
  end
end