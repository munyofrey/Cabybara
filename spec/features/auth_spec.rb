require 'spec_helper'
require 'rails_helper'



feature "the signup process" do
  before(:each) do visit new_user_url end

  scenario "has a new user page" do
    expect(page).to have_content("Sign Up")
    expect(page).to have_button("Sign Up")
  end

  feature "signing up a user" do

    scenario "shows username on the homepage after signup" do
      fill_in "Username", with: "BobbyO"
      fill_in "Password", with: "Password"
      click_on "Sign Up"
      expect(page).to have_content("BobbyO")
    end

  end

end

feature "logging in" do

  let!(:user) {User.create(username: 'BobbyO', password: 'Password')}

 before(:each) do
   visit new_session_url
   fill_in "Username", with: "BobbyO"
   fill_in "Password", with: "Password"
   click_on 'Log In'
 end

  scenario "shows username on the homepage after login" do
    expect(page).to have_content('BobbyO')
  end

end

feature "logging out" do
  let!(:user) {User.create(username: 'BobbyO', password: 'Password')}
  scenario "begins with a logged out state" do
    visit user_url(1)
    expect(current_path).to eq(new_session_path)
  end

  scenario "doesn't show username on the homepage after logout" do
    visit new_session_url
    fill_in "Username", with: "BobbyO"
    fill_in "Password", with: "Password"
    click_on 'Log In'
    click_on 'Log Out'
    expect(page).not_to have_content('BobbyO')
    expect(current_path).to eq(new_session_path)
  end

end
