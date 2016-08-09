require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  let!(:user) {User.create(username: 'BobbyO', password: 'Password')}

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    context "when entering valid params" do
      it "logs the user in" do
        post :create, user: {username: "BobbyO", password: "Password"}
        user = User.find_by(username: "BobbyO")
        expect(session[:session_token]).to eq(user.session_token)
      end
      it 'redirects to user show page' do
        post :create, user: {username: "BobbyO", password: "Password"}
        user = User.find_by(username: "BobbyO")
        expect(:response).to redirect_to(user_url(user))
      end
    end
    context "when entering invalid params" do
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
      it 'validates that the username and password are correct' do
        post :create, user: {username: "BobbyO", password: "Passwor"}
        expect(:response).to render_template(:new)
        expect(flash[:errors]).to be_present
      end
    end
  end

  describe "DELETE #destroy" do
    it "logs the user out" do
      post :create, user: {username: "BobbyO", password: "Password"}
      user = User.find_by(username: 'BobbyO')
      session_token_user = user.session_token
      delete :destroy
      expect(user.session_token).not_to be(session_token_user)
    end
  end

end
