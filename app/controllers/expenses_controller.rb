class ExpensesController < ApplicationController
  def new
    @expense = Expense.new
  end
end
