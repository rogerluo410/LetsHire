FactoryGirl.define do
  factory :department do
    name Faker::Name.name
    description (Random.rand * 10000).to_i.to_s
  end
end

