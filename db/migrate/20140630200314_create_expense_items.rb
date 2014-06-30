class CreateExpenseItems < ActiveRecord::Migration
  def change
    create_table :expense_items do |t|
      t.datetime :expensed_at,               null: false
      t.string   :description, default: '',  null: false
      t.string   :comment,     default: '',  null: false
      t.decimal  :amount,      default: 0.0, null: false

      t.timestamps
    end

    add_reference :expense_items, :user, index: true, null: false
  end
end
