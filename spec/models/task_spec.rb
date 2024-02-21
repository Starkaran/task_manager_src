require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      user = FactoryBot.create(:user)
      task = FactoryBot.build(:task, user: user, title: 'Blog', status: 'To Do')
      expect(task).to be_valid
    end

    it "is not valid without a title" do
      task = FactoryBot.build(:task, title: nil)
      expect(task).not_to be_valid
    end

    it "is not valid with an invalid status" do
      task = FactoryBot.build(:task, status: "Invalid Status")
      expect(task).not_to be_valid
    end
  end

  describe "check_todo_percentage callback" do
    user = FactoryBot.create(:user)

    it "does not allow creation of new To Do task if existing todo tasks are >= 50% of total tasks" do
      FactoryBot.create_list(:task, 5, status: 'To Do', user: user, title: 'Blog')
      task = FactoryBot.build(:task, status: 'To Do', user: user, title: 'New Blog')
      expect(task).not_to be_valid
      expect(task.errors[:base]).to include('Cannot create new To Do task')
    end

    it "allows creation of new To Do task if existing todo tasks are < 50% of total tasks" do
      FactoryBot.create_list(:task, 4, status: 'To Do', user: user, title: 'Blog')
      task = FactoryBot.build(:task, status: 'To Do', user: user, title: 'New Blog')
      expect(task).to be_valid
    end
  end
end
