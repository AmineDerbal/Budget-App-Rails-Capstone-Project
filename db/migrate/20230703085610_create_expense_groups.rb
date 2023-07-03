class CreateExpenseGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :expense_groups do |t|
      t.integer :group_id
      t.integer :expense_id

      t.timestamps
    end
    add_foreign_key :expense_groups, :groups, column: :group_id
    add_foreign_key :expense_groups, :expenses, column: :expense_id
    add_index :expense_groups, :group_id
    add_index :expense_groups, :expense_id
  end
end
