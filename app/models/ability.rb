class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user

    return unless user.present?

    can(:read, Group, author_id: user.id)
    can(:read, Expense, author_id: user.id)
    can(:read, User, id: user.id)
  end
end
