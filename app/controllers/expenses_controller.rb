class ExpensesController < ApplicationController
  before_action :set_expense, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.new(expense_params)

    if @expense.save
      redirect_to @expense, notice: 'Expense was successfully created.'
    else
      render action: 'new'
    end
  end


  private
    def set_expense
      @expense = Expense.find(params[:id])
    end

    def expense_params
      params[:expense].permit!
    end
end
