require 'csv'

class TransactionDecorator < Draper::Decorator
  delegate_all

  def date
    object.date.strftime("%-m/%-d/%Y")
  end

  def amount
    "$#{object.amount}"
  end

  def as_json
    {
      merchant: object.merchant,
      categories: object.category_list,
      date: object.date,
      amount: object.amount.to_s,
      transaction_type: object.transaction_type
    }
  end
end
