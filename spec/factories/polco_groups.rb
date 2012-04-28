# groups can be
#[:custom, :state, :district, :common, :country]

FactoryGirl.define do
  factory :polco_group do
    name {Faker::Company.name}
    type :custom
    description {Faker::Company.bs}
  end

  factory :oh, class: PolcoGroup do
    name 'OH'
    type :state
  end

  factory :district, class: PolcoGroup do
    name 'VA08'
    type :district
  end

  factory :common, class: PolcoGroup do
    name 'common'
    description 'common group for all of polco'
    type :common
  end

end