require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe 'GET #new' do
    it 'directs to the new page' do
      get :new
      expect(:response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'when given valid parameters' do
      it 'redirects to user show page' do
        post :create, user: {username: "BobbyO", password: "Password"}
        user = User.find_by(username: "BobbyO")
        expect(:response).to redirect_to(user_url(user))
      end
      it 'logs the user in' do
        post :create, user: {username: "BobbyO", password: "Password"}
        user = User.find_by(username: "BobbyO")
        expect(session[:session_token]).to eq(user.session_token)
      end
    end
    context 'when given invalid parameters' do
      it 'validates the presence of username' do
        post :create, user: {username: "", password: "Password"}
        expect(:response).to render_template(:new)
        expect(flash[:errors]).to be_present
      end
      it 'validates the presence of password' do
        post :create, user: {username: "BobbyO", password: ""}
        expect(:response).to render_template(:new)
        expect(flash[:errors]).to be_present
      end
      it 'validates the password to be at least 6 characters long' do
        post :create, user: {username: "BobbyO", password: "Pass"}
        expect(:response).to render_template(:new)
        expect(flash[:errors]).to be_present
      end
    end
  end

end
