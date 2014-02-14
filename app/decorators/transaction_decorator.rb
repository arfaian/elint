class TransactionDecorator < Draper::Decorator
  delegate_all

  def date
    object.date.strftime("%m/%d/%Y")
  end

  def sum
    "$#{object.sum}"
  end
end
