require 'rails_helper'

RSpec.describe 'Categories visit index ', type: :feature do
  include Devise::Test::IntegrationHelpers
  include ActionView::Helpers::NumberHelper
  before(:each) do
    @user = User.create(email: 'user@example.com', password: 'password', name: 'user')
    @user.confirm
    sign_in @user
    @group = @user.groups.create(name: 'test', icon: 'icons8-logout-64.png')
    @expense = @user.expenses.create(name: 'test', amount: 100)
    @expense_group = ExpenseGroup.create(group_id: @group.id, expense_id: @expense.id)
    @expense_sum = number_with_precision(@group.expenses.sum(:amount), precision: 2)
    visit root_path
  end

  it 'should show list of categories' do
    expect(page).to have_content("List of Categories of #{@user.name}")
  end
  it 'should show category data' do
    expect(page).to have_content(@group.name)
    expect(page).to have_content(@expense.created_at.strftime('%d %b %Y'))
    expect(page).to have_content(@expense_sum)
    image_name = File.basename(@group.icon, '.*')
    expect(page).to have_css("img[src*=\"#{image_name}\"]")
  end

  it 'should redirect to add category and go back to index page' do
    expect(page).to have_link('ADD CATEGORY')
    click_link 'ADD CATEGORY'
    expect(page).to have_current_path(new_group_path)
    expect(page).to have_link(href: '/')
    click_link href: '/'
    expect(page).to have_current_path(groups_path)
  end
end
