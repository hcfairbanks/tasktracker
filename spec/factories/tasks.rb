FactoryBot.define do
  factory :task do
    title {"test task"}
    description {"test description"}
    association :reported_by, factory: :user
    association :assigned_to, factory: :user
    association :status, factory: :status
    association :request_type, factory: :request_type
    member_facing {true}
    association :vertical, factory: :vertical
    link {"www.testlink.com"}
    required_by {Date.today}
    association :priority, factory: :priority
  end
end
