class AddPartitionStartDateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :partition_start_date, :date
  end
end
