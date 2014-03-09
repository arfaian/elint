@transactions.each do |category, transactions|
  json.set! category do
    json.array! transactions, partial: 'transactions/transaction_by_category', as: :transaction
  end
end
