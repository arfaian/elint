class RenameExpensesToTransactions < ActiveRecord::Migration
  def change
    rename_table :expenses, :transactions
  end
end
