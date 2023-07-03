class User < ApplicationRecord
has_many :expenses,class_name: "Expense", foreign_key: "author_id"
has_many :groups,class_name: "Group", foreign_key: "author_id"


validates :name, presence: true


end