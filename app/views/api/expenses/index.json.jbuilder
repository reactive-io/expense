json.expenses @expenses do |expense|
  json.id          expense.id
  json.description expense.description
  json.comment     expense.comment
  json.amount      expense.amount
  json.created_at  expense.created_at
  json.updated_at  expense.updated_at
  json.expensed_at expense.expensed_at
end