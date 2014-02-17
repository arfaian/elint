class RecurringTransactionsJob
  include SuckerPunch::Job
  workers 1

  def perform
    ActiveRecord::Base.connection_pool.with_connection do
      Transaction.current_month.recurring_today.each do |transaction|
        new_transaction = transaction.dup
        new_transaction.date = Date.today
        new_transaction.recurrence_date = transaction.recurrence_interval.date
        new_transaction.save
      end
    end
  end
end
