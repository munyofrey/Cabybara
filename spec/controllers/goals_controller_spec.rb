require 'rails_helper'

RSpec.describe GoalsController, type: :controller do

  describe 'GET #index' do
    it 'renders the index page' do
      get :index
      expect(:response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    it "renders the show page" do
      goal = FactoryGirl.create(:goal, user_id: 2, title: "title", details: "wowowowowowowow")
      get :show, id: goal.id
      expect(:response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    create_nancy
    context "when logged in" do
      before do
        allow(controller).to receive(:current_user) {nancy}
      end
    it "renders the new page" do
      get :new
      expect(:response).to render_template(:new)
    end
end
    context "when not logged in" do
      before do
        get :new
        allow(controller).to receive(:current_user) { nil }
      end
    it "redirects to log in page if not logged in" do
      expect(:response).to redirect_to(new_session_url)
    end
  end
  end

  describe 'POST #create' do
    create_nancy
    context "when logged in" do
      before do
        allow(controller).to receive(:current_user) {nancy}
      end
    it "redirects to the show page of the goal" do
      post :create, goal: {title: "Hi", details: "I'm a stupid goal"}
      goal = Goal.find_by(title: "Hi")
      expect(:response).to redirect_to(goal_url(goal))
    end
    it "rerenders form on with incorrect parameters" do
      post :create, goal: {title: "Hi"}
      expect(:response).to render_template(:new)
    end
  end

    context "when not logged in" do
      before do
        allow(controller).to receive(:current_user) { nil }
      end
      it "redirects to log in page if not logged in" do
        post :create, goal: {title: "Hi", details: "I'm a stupid goal"}
        expect(:response).to redirect_to(new_session_url)
      end
    end
  end

  describe 'GET #edit' do
    create_nancy
    context "when logged in" do
      before do
        allow(controller).to receive(:current_user) {nancy}
      end
    it "renders the edit form" do
      goal = FactoryGirl.create(:goal, user_id: 1, title: "title", details: "wowowowowowowow")
      get :edit, id: goal.id
      expect(:response).to render_template(:edit)
    end
  end

    context "when not logged in" do
      before do
        allow(controller).to receive(:current_user) { nil }
      end
      it "redirects to log in page if not logged in" do
        goal = FactoryGirl.create(:goal, user_id: 1, title: "title", details: "wowowowowowowow")
        get :edit, id:goal.id
        expect(:response).to redirect_to(new_session_url)
      end
    end
  end

  describe 'POST #update' do
    create_nancy
    context "when logged in" do
      before do
        allow(controller).to receive(:current_user) {nancy}
      end

    it "doesn't let you update someone else's goals" do
      goal = FactoryGirl.create(:goal, user_id: 2, title: "title", details: "wowowowowowowow", id: 2)
      patch :update, id: goal.id, title: "fafafa"
      goal = Goal.find_by_id(2)
      expect(goal.title).to eq("title")
    end


    it 'updates with valid params' do
      goal = FactoryGirl.create(:goal, user_id: 1, title: "title", details: "wowowowowowowow", id: 2)
      patch :update, id: goal.id, goal: {title: "fafafa"}
      goal = Goal.find_by_id(2)
      expect(goal.title).to eq("fafafa")
    end

    it 'renders template with invalid params' do
      goal = FactoryGirl.create(:goal, user_id: 1, title: "title", details: "wowowowowowowow", id: 2)
      patch :update, id: goal.id, goal: {title: ""}
      goal = Goal.find_by_id(2)

      expect(:response).to render_template(:edit)
    end
  end

    context "when not logged in" do
      before do
        allow(controller).to receive(:current_user) { nil }
      end
      it "redirects to log in page if not logged in" do
        goal = FactoryGirl.create(:goal, user_id: 2, title: "title", details: "wowowowowowowow", id: 2)
        patch :update, id: goal.id, title: "fafafa"
        goal = Goal.find_by_id(2)
        expect(:response).to redirect_to(new_session_url)
      end
    end


  end

  describe 'DELETE #destroy' do
    create_nancy

    context "when logged in" do
      before do
        allow(controller).to receive(:current_user) {nancy}
      end
      it 'deletes goals' do
        goal = FactoryGirl.create(:goal, user_id: 1, title: "title", details: "wowowowowowowow")
        delete :destroy, id: goal.id
        expect(Goal.find_by_id(goal.id)).to be(nil)
      end

      it 'doesn\'t let you delete someone else\'s goals' do
        goal = FactoryGirl.create(:goal, user_id: 2, title: "title", details: "wowowowowowowow")
        delete :destroy, id: goal.id
        expect(Goal.find_by_id(goal.id)).not_to be(nil)
      end
    end

    context "when not logged in" do
      before do
        allow(controller).to receive(:current_user) { nil }
      end
      it 'redirect if not logged in' do
        goal = FactoryGirl.create(:goal, user_id: 1, title: "title", details: "wowowowowowowow")
        delete :destroy, id: goal.id
        expect(:response).to redirect_to(new_session_url)
      end
    end
  end




end
