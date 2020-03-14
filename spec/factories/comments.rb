FactoryBot.define do
  factory :comment do
    user { :user }
    task { :task }
    content { "Some content" }
  end
end
