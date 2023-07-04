class Expense < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  has_many :expense_groups, class_name: 'ExpenseGroup', foreign_key: 'group_id', dependent: :destroy
  has_many :groups, through: :expense_groups

  accepts_nested_attributes_for :expense_groups

  validates :name, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :author_id, presence: true
end
