require 'csv'

class TransactionDecorator < Draper::Decorator
  delegate_all

  def date
    object.date.strftime("%-m/%-d/%Y")
  end

  def sum
    "$#{object.sum}"
  end

  def as_json
    {
      merchant: object.merchant,
      category: object.category,
      date: object.date,
      amount: object.sum.to_s,
      transaction_type: object.transaction_type
    }
  end
end
