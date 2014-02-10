class ExpenseDecorator < Draper::Decorator
  def cost
    cost / 100.0
  end
end
