class ExpenseDecorator < Draper::Decorator
  delegate_all

  def date
    object.date.strftime("%m/%d/%Y")
  end

  def merchant
    object.merchant
  end

  def description
    object.description
  end

  def category
    object.category
  end

  def cost
    "$#{object.cost}"
  end
end
