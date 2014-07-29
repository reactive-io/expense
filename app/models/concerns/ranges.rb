module Ranges
  extend ActiveSupport::Concern

  included do
    scope :range, -> (field) {
      table = Arel::Table.new(self.table_name)

      relation = select([table[field].minimum.as('min'), table[field].maximum.as('max')])

      relation.map { |item| item.serializable_hash.slice('min', 'max') }.first
    }
  end
end
