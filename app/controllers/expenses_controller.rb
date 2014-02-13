class ExpensesController < ApplicationController
  before_action :set_expense, only: [:show, :edit, :update, :destroy]

  def index
    @expenses = decorate(Expense.all.to_a)
  end

  def show
    @expense = decorate(@expense)
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

  def tagged
    if params[:tag].present?
      @expenses = decorate(Expense.tagged_with(params[:tag]))
    else
      @expenses = decorate(Expense.all.to_a)
    end
    render :index
  end

  private
    def set_expense
      @expense = Expense.find(params[:id])
    end

    def expense_params
      params[:expense].permit!
    end

    def decorate(expense)
      if expense.is_a?(Array)
        ExpenseDecorator.decorate_collection(expense)
      elsif expense.is_a?(Expense)
        expense.decorate
      else
        expense
      end
    end
end
