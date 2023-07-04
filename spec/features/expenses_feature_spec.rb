require 'rails_helper'

RSpec.describe 'Expenses visit index ', type: :feature do
  include Devise::Test::IntegrationHelpers
  include ActionView::Helpers::NumberHelper
  before(:each) do
    @user = User.create(email: 'user@example.com', password: 'password', name: 'user')
    @user.confirm
    sign_in @user
    @group = @user.groups.create(name: 'group', icon: 'icons8-logout-64.png')
    @group2 = @user.groups.create(name: 'group2', icon: 'icons8-logout-64.png')
    @expense1 = @user.expenses.create(name: 'exp1', amount: 100)
    @expense2 = @user.expenses.create(name: 'exp2', amount: 70)
    @expense3 = @user.expenses.create(name: 'exp3', amount: 50)
    @expense_group = ExpenseGroup.create(group_id: @group.id, expense_id: @expense1.id)
    @expense_group2 = ExpenseGroup.create(group_id: @group.id, expense_id: @expense2.id)
    @expense_group3 = ExpenseGroup.create(group_id: @group2.id, expense_id: @expense3.id)
    @expense_sum = number_with_precision(@group.expenses.sum(:amount), precision: 2)
    visit group_expenses_path(@group)
  end

  it 'should show list of expenses' do
    expect(page).to have_content('List of expenses')
  end

  it 'should show all expenses data only for @group ' do
    expect(page).to have_content(@expense_sum)
    expect(page).to have_content(@expense1.name)
    expect(page).to have_content(@expense1.created_at.strftime('%d %b %Y'))
    expect(page).to have_content(@expense1.amount)
    expect(page).to have_content(@expense2.name)
    expect(page).to have_content(@expense2.created_at.strftime('%d %b %Y'))
    expect(page).to have_content(@expense2.amount)
    expect(page).not_to have_content(@expense3.name)
    expect(page).not_to have_content(@expense3.amount)
  end

  it 'should redirect to home page ' do
    expect(page).to have_link(href: '/')
    click_link href: '/'
    expect(page).to have_current_path(groups_path)
  end

  it 'should redirect to add expense and go back to index page' do
    expect(page).to have_link('ADD EXPENSE')
    click_link 'ADD EXPENSE'
    expect(page).to have_current_path(new_group_expense_path(@group))
    expect(page).to have_link(href: "/categories/#{@group.id}/expenses")
    click_link href: "/categories/#{@group.id}/expenses"
    expect(page).to have_current_path(group_expenses_path(@group))
  end
end
