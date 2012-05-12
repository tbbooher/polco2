require 'spec_helper'

#House Bills

# the eballot allows the user to vote (or shows what the user had voted on the bill) post a comment on the bill (or show the comment the user had created)
#Districts and Reps
#H Representation
#Senate Bills
#States
#S Representation

describe "Bills" do
  describe "House Bills" do
    it "should show the 5 most popular bills that the user hasn't voted on and haven't been roll called" do
      u = FactoryGirl.create(:user)

      visit represent_house_bills_path
      bills = Bill.introduced_house_bills
      page.should have_content(bills.first.bill_title)
    end
    it "should show the three most recent bills a user has voted on" do
      pending
    end
  end
end
