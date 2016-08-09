# == Schema Information
#
# Table name: goals
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  details    :text             not null
#  private    :boolean          default(FALSE)
#  completed  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

require 'rails_helper'

RSpec.describe Goal, type: :model do

  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:details)}
  it {should validate_presence_of(:completed)}
  it {should validate_presence_of(:private)}
  it {should validate_presence_of(:user)}

end
