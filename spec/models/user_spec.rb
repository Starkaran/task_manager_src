require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  it "is not valid without an email" do
    user = FactoryBot.build(:user, email: nil)
    expect(user).not_to be_valid
  end

  it "is not valid with a duplicate email" do
    user = FactoryBot.create(:user)
    duplicate_user = FactoryBot.build(:user, email: user.email)
    expect(duplicate_user).not_to be_valid
  end

  it "is not valid without a password" do
    user = FactoryBot.build(:user, password: nil)
    expect(user).not_to be_valid
  end

  # Add more examples to test other validations and associations
end
