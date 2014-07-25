class ExpenseItem < ActiveRecord::Base
  default_scope { order('id ASC') }

  belongs_to :user

  validates :expensed_at, :description, :amount, :user_id, presence: true
  validates :amount, numericality: true

  class << self
    def ransackable_attributes(auth_object = nil)
      %w[id amount expensed_at description comment]
    end

    def ransortable_attributes(auth_object = nil)
      %w[id amount expensed_at]
    end
  end
end
