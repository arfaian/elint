class ExpenseDecorator < Draper::Decorator
  delegate_all

  def date
    object.date.strftime("%m/%d/%Y")
  end

  def cost
    "$#{object.cost}"
  end
end
