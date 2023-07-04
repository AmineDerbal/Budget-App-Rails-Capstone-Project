class ExpenseGroup < ApplicationRecord
  belongs_to :group, class_name: 'Group', foreign_key: 'group_id'
  belongs_to :expense, class_name: 'Expense', foreign_key: 'expense_id'

  validates :group_id, presence: true
  validates :expense_id, presence: true
end
