module Facets
  extend ActiveSupport::Concern

  included do
    scope :facet, -> (field, order = :name) {
      table = Arel::Table.new(self.table_name)

      relation = select([table[field].as('name'), table[:id].count.as('count')]).group(table[field])

      relation = case order
                   when :name
                     relation.order(['name ASC', 'count ASC'])
                   when :count
                     relation.order(['count ASC', 'name ASC'])
                   else
                     raise ArgumentError.new('You must pass either ":name", or ":count" for order.')
                 end

      relation.map { |item| item.serializable_hash.slice('name', 'count') }
    }
  end
end
