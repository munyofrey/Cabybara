# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do

  subject(:user) do
  FactoryGirl.build(:user,
    username: "jonathan",
    password: "good_password")
  end


  it {should validate_presence_of(:username)}
  it {should validate_presence_of(:password_digest)}

  it {should have_many(:goals)}

  it {should validate_length_of(:password).is_at_least(6)}

  describe '#completed_goals' do
    let!(:user) {User.create(username: "jonathan", password: "password", id: 1)}
    it ' returns an array of goals' do

      3.times do FactoryGirl.create(:goal,
        title: "Goal",
        details: "abcd",
        user_id: 1,
        completed: true) end

      expect(user.completed_goals.length).to eq(3)

    end
  end


  describe '#password=' do
    it ' to set a password digest' do
      user = User.new
      before_password_digest = user.password_digest
      user.password = "password"
      expect(before_password_digest).not_to eq(user.password_digest)
      expect(user.password).to eq("password")
    end
  end

  describe '.generate_session_token' do
    it ' returns a string of 43 characters' do
      expect(User.generate_session_token.length).to eq(43)
    end
  end

  describe '.find_by_credentials' do
    it 'returns nil if no user present' do
      expect(User.find_by_credentials("jonathan", "good_password")).to be(nil)
    end
    it 'returns correct user' do
      FactoryGirl.create(:user,
        username: "jonathan",
        password: "good_password")
      expect(User.find_by_credentials("jonathan", "good_password").username).to eq('jonathan')
    end
  end

  describe '#ensure_session_token' do
    it 'lazy initializes session_token' do
      first_session_token = user.session_token
      user.ensure_session_token
      expect(user.session_token).to be(user.session_token)
    end
  end

  describe '#reset_sesion_token!' do
    it 'returns the users session token' do
      expect(user.reset_session_token!).to be(user.session_token)
    end

    it 'change the user session_token' do
      old_session = user.session_token
      user.reset_session_token!
      expect(user.session_token).not_to be(old_session)
    end

  end



end
