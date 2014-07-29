json.counts @query.counts
json.facets @query.facets
json.ranges @query.ranges

json.result @query.result, partial: 'expense', as: :item
