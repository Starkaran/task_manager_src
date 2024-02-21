require 'faker'

FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    status { ['To Do', 'In Progress', 'Done'].sample }
  end
end