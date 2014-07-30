module Fulltext
  extend ActiveSupport::Concern

  included do
    scope :fulltext, -> (query, fuzzy = false) {
      where(
          Arel::Nodes::InfixOperation.new(
              '@@',
              Arel::Table.new(self.table_name)[:fulltext_terms],
              Arel::Nodes::NamedFunction.new('to_tsquery', [query.to_tsquery(fuzzy)])
          )
      )
    }
  end
end
