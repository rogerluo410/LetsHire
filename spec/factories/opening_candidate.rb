FactoryGirl.define do
  factory :opening_candidate do
    opening_id    Random.rand(10)
    candidate_id  Random.rand(10)
  end
end
