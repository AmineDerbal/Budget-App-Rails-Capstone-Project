class ExpensesController < ApplicationController
  def index
    @user = current_user
    @group = Group.find(params[:group_id])
    @expenses = @group.expenses.order(created_at: :desc)
    @expenses_sum = @expenses.sum(:amount) || 0
  end

  def new
    @user = current_user
    @group = Group.find(params[:group_id])
    @categories = @user.groups
    @expense = Expense.new
  end

  def create
    @user = current_user
    @group = Group.find(params[:group_id])
    category_ids = params[:expense][:category_ids]

    if category_ids.present?

      @expense = Expense.new(expense_params.except(:category_ids))
      @expense.author = @user
      if @expense.save
        category_ids.each do |category_id|
          ExpenseGroup.create(group_id: category_id.to_i, expense_id: @expense.id)
        end
        redirect_to group_expenses_path(@group)

      else
        redirect_to new_group_expense_path(@group, notice: 'Failed to create expense')

      end
    else

      redirect_to new_group_expense_path(@group, notice: 'Please select at least one category')

    end
  end

  private

  def expense_params
    params.require(:expense).permit(:name, :amount, category_ids: [])
  end
end
