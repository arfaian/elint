class TransactionsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  def index
    transactions = current_user.transactions.current_month
                      .order(:date).includes(:tags).includes(:categories).to_a
    @header = Date.today.strftime('%B %Y')
    @transactions = decorate(transactions)
  end

  def by_year
    year = params[:year].to_i
    @date = Date.new(year)
    @header = @date.strftime('%Y')
    transactions = current_user.transactions.by_year(@date)
    @transactions = decorate(transactions)
    render :index
  end

  def by_month
    year = params[:year].to_i
    month = params[:month].to_i
    @date = Date.new(year, month)
    @header = @date.strftime('%B %Y')
    transactions = current_user.transactions.by_month(@date)
    @transactions = decorate(transactions)
    render :index
  end

  def by_category
    categories = params[:categories]
    transactions = current_user.transactions.by_category(categories)
    @transactions = decorate(transactions)
    @header = categories
    render :index
  end

  def show
    @transaction = decorate(@transaction)
  end

  def new
    @transaction = Transaction.new
  end

  def update
    if @transaction.update(transaction_params)
      @transaction.update_tags_and_categories(current_user)
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
      @transaction.update_tags_and_categories(current_user)
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
      redirect_to(transactions_path, notice: 'transaction not found') unless @transaction
      @transaction
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
