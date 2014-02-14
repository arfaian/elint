class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string :merchant
      t.string :category
      t.text :note
      t.date :date
      t.boolean :avoidable
      t.money :cost

      t.timestamps
    end
  end
end
