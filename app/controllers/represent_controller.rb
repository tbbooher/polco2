class RepresentController < ApplicationController
  def house_bills
    @bills = Bill.introduced_house_bills
  end

  def senate_bills
    @bills = Bill.introduced_senate_bills
  end

end
