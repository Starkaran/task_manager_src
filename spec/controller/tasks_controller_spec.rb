require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:task) { FactoryBot.create(:task, user: user, title: 'Blog', status: 'To Do') }

  before { sign_in user }

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Task" do
        expect {
          post :create, params: { task: FactoryBot.attributes_for(:task) }
        }.to change(Task, :count).by(1)
      end

      it "renders a JSON response with the new task" do
        post :create, params: { task: FactoryBot.attributes_for(:task) }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new task" do
        post :create, params: { task: FactoryBot.attributes_for(:task, title: nil) }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { title: 'New Title' } }

      it "updates the requested task" do
        put :update, params: { id: task.to_param, task: new_attributes }
        task.reload
        expect(task.title).to eq('New Title')
      end

      it "renders a JSON response with the task" do
        put :update, params: { id: task.to_param, task: new_attributes }
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the task" do
        put :update, params: { id: task.to_param, task: FactoryBot.attributes_for(:task, title: nil) }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested task" do
      task = Task.create! FactoryBot.attributes_for(:task, user: user)
      expect {
        delete :destroy, params: { id: task.to_param }
      }.to change(Task, :count).by(-1)
    end

    it "returns a no_content response" do
      task = Task.create! FactoryBot.attributes_for(:task, user: user)
      delete :destroy, params: { id: task.to_param }
      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'GET #sort_by_due_date' do
    it 'returns a successful response' do
      FactoryBot.create_list(:task, 5, status: 'To Do', user: user, title: 'Blog')
      get :sort_by_due_date
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #search' do
    it 'returns a successful response' do
      FactoryBot.create_list(:task, 5, status: 'To Do', user: user, title: 'Blog')
      get :search, params: { query: 'Blog' }
      expect(response).to have_http_status(:ok)
    end
  end
end
