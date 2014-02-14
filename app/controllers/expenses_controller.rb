class ExpensesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_expense, only: [:show, :edit, :update, :destroy]

  def index
    @expenses = decorate(current_user.expenses)
  end

  def show
    @expense = decorate(@expense)
  end

  def new
    @expense = Expense.new
  end

  def update
    if @expense.update(expense_params)
      redirect_to @expense, notice: 'expense was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def saved
    API::Expenses.new.saved(current_user)
    current_user.expenses.current_month.select(&:cost)
  end

  def create
    @expense = Expense.new(expense_params)

    if @expense.save
      redirect_to @expense, notice: 'expense was successfully created.'
    else
      render action: 'new'
    end
  end

  def tagged
    if params[:tag].present?
      @expenses = decorate(Expense.tagged_with(params[:tag]))
    else
      @expenses = decorate(current_user.expenses)
    end
    render :index
  end

  private
    def set_expense
      @expense = current_user.expenses.where(id: params[:id]).first
    end

    def expense_params
      params[:expense].permit!.merge!(user_id: current_user.id)
    end

    def decorate(expense)
      if expense.is_a?(Array) || expense.is_a?(ActiveRecord::Associations::CollectionProxy)
        ExpenseDecorator.decorate_collection(expense)
      elsif expense.is_a?(Expense)
        expense.decorate
      else
        expense
      end
    end
end
