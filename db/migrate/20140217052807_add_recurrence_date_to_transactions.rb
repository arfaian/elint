class AddRecurrenceDateToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :recurrence_date, :date
  end
end
