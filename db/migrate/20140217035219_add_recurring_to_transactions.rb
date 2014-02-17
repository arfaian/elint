class AddRecurringToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :recurring, :boolean
  end
end
