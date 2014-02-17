class AddRecurrenceIntervalToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :recurrence_interval, :string
  end
end
