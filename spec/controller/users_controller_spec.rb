# spec/controllers/users_controller_spec.rb

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST #create' do
    context 'when user exists' do
      let(:user_params) { { name: 'karan deol', email: 'karan@example.com', password: 'password' } }
      let!(:existing_user) { FactoryBot.create(:user, email: 'karan@example.com') }

      it 'signs in the user' do
        post :create, params: { user: user_params }
        expect(response).to have_http_status(:ok)
        expect(controller.current_user).to eq(existing_user)
      end
    end

    context 'when user does not exist' do
      let(:user_params) { { name: 'karan', email: 'jane@example.com', password: 'password' } }

      it 'creates a new user and signs in' do
        expect {
          post :create, params: { user: user_params }
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        new_user = User.find_by(email: 'jane@example.com')
        expect(controller.current_user).to eq(new_user)
      end
    end

    context 'with invalid params' do
      let(:invalid_user_params) { { name: '', email: '', password: '' } }

      it 'does not create a new user and returns unprocessable entity' do
        post :create, params: { user: invalid_user_params }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
