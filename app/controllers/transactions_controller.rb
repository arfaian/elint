class TransactionsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  def index
    transactions = current_user.transactions.current_month.order(:date).to_a
    @transactions = decorate(transactions)
  end

  def show
    @transaction = decorate(@transaction)
  end

  def new
    @transaction = Transaction.new
  end

  def update
    if @transaction.update(transaction_params)
      redirect_to @transaction, notice: 'transaction was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def type
    type = params[:type] if %w{credits debits}.include?(params[:type])
    if type.nil?
      head :not_found
      return
    end
    transactions = decorate(current_user.transactions.send(type.to_sym))
    transactions = TransactionDecorator.decorate_collection(transactions)
    respond_to do |format|
      format.json {
        json = {}
        json[type] = transactions.as_json
        render json: json.to_json
      }
    end
  end

  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      redirect_to @transaction, notice: 'transaction was successfully created.'
    else
      render action: 'new'
    end
  end

  def tagged
    if params[:tag].present?
      @transactions = decorate(Transaction.tagged_with(params[:tag]))
    else
      @transactions = decorate(current_user.transactions)
    end
    render :index
  end

  private
    def set_transaction
      @transaction = current_user.transactions.where(id: params[:id]).first
    end

    def transaction_params
      params[:transaction].permit!.merge!(user_id: current_user.id)
    end

    def decorate(transaction)
      if transaction.is_a?(Array) || transaction.is_a?(ActiveRecord::Associations::CollectionProxy)
        TransactionDecorator.decorate_collection(transaction)
      elsif transaction.is_a?(Transaction)
        transaction.decorate
      else
        transaction
      end
    end
end
