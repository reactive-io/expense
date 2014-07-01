class ExpenseItem < ActiveRecord::Base
  default_scope { order('id ASC') }

  belongs_to :user

  validates :expensed_at, :description, :amount, :user_id, presence: true
  validates :amount, numericality: true
end
