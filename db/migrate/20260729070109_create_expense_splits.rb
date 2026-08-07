class CreateExpenseSplits < ActiveRecord::Migration[8.1]
  def change
    create_table :expense_splits do |t|
      t.references :expense, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2

      t.timestamps
    end
  end
end