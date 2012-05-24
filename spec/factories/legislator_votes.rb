# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :legislator_vote do
    value "aye"
    roll {FactoryGirl.create(:roll)}
  end
end
