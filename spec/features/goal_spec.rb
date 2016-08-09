require 'rails_helper'

  feature 'shows logged in user\'s goals' do
    create_nancy
    scenario 'a user is logged in and sees goals' do
      login
      expect(page).to have_content("Have Coffee")
    end

    scenario 'a user can click on their goals by their titles' do
      login
      click_on("Have Coffee")
      expect(current_path).to eq(goal_path(1))
    end
  end

  feature 'allows having a new goal' do
    create_nancy
    before(:each) do
      login
    end
    scenario 'allows goals with valid params' do
      create_goal("title", "deets")
      expect(Goal.last.title).to eq("title")
    end
    scenario 'renders add again if invalid parameters' do
      create_goal("title")
      expect(current_path).to eq(goals_path)
    end
    scenario 'shows errors if invalid parameters' do
      create_goal("title")
      expect(page).to have_content "Details can't be blank"
    end
  end

  feature 'shows goal page' do
    create_nancy
    before(:each) do
      login
      click_link 'Have Coffee'
    end

    scenario 'deletes own goal' do
      click_on 'Delete Goal'
      expect(current_path).to eq(user_path(nancy))
      expect(page).not_to have_content("Have Coffee")
    end

    scenario 'can edit own goal' do
      click_on 'Edit Goal'
      fill_in "Details", with: "I am an edit!"
      click_on "Update Goal"
      expect(page).to have_content("I am an edit!")
    end
  end
