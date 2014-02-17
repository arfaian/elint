class RenameSumCentsToAmountCents < ActiveRecord::Migration
  def change
    rename_column :transactions, :sum_cents, :amount_cents
  end
end
