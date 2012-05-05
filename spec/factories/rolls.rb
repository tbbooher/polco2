# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :roll do
    result "MyString"
    required "MyString"
    type ""
    question "MyString"
    category "MyString"
    ayes 1
    nays 1
    nv 1
    present 1
    session 1
    year 1
    datetime "2012-05-04 21:16:52"
    updated "2012-05-04 21:16:52"
    where "MyString"
  end
end
