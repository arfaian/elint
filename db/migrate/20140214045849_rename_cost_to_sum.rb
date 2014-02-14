class RenameCostToSum < ActiveRecord::Migration
  def change
    rename_column :transactions, :cost_cents, :sum_cents
  end
end
