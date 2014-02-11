class ExpenseDecorator < Draper::Decorator

  def date
    object.date.strftime("%m/%d/%Y")
  end

  def merchant
    object.merchant
  end

  def category
    object.category
  end

  def cost
    '$' + h.number_with_precision(object.cost / 100.0, :precision => 2).to_s
  end
end
