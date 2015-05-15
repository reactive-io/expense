class ExpenseItem < ActiveRecord::Base
  include Fulltext
  include Facets
  include Ranges

  belongs_to :user

  validates :expensed_at, :description, :amount, :user_id, presence: true
  validates :amount, numericality: true

  class << self
    def ransackable_attributes(auth_object = nil)
      %w[id amount expensed_at description comment search_terms]
    end

    def ransackable_scopes(auth_object = nil)
      %w[fulltext]
    end

    def ransortable_attributes(auth_object = nil)
      %w[id amount expensed_at]
    end

    def facetable_attributes
      %w[comment description]
    end

    def rangable_attributes
      %w[amount expensed_at]
    end
  end
end
