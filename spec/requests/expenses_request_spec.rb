require 'rails_helper'

RSpec.describe 'Expenses', type: :request do
  include Devise::Test::IntegrationHelpers

  describe 'GET /expenses' do
    before(:each) do
      @user = User.create(email: 'user@example.com', password: 'password', name: 'user')
      @user.confirm
      sign_in @user
      @group = @user.groups.create(name: 'test', icon: 'icons8-logout-64.png')
      @expense = @user.expenses.create(name: 'test', amount: 100)
      @expense_group = ExpenseGroup.create(group_id: @group.id, expense_id: @expense.id)

      get "/categories/#{@group.id}/expenses"
    end
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'return 200' do
      expect(response.status).to eq(200)
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end

    it 'include the list of all expenses' do
      expect(response.body).to include('List of expenses')
    end
  end
end
