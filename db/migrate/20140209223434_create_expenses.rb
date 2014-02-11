class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string :merchant
      t.string :category
      t.string :description
      t.string :note
      t.date :date
      t.boolean :avoidable
      t.integer :cost

      t.timestamps
    end
  end
end
