class RepresentController < ApplicationController

  def house_bills
    if @user = current_user
      @voted_on_bills = @user.bills_voted_on(:house).page(params[:voted_on]).per(5)
      @not_voted_on_bills = @user.bills_not_voted_on(:house).page(params[:not_voted_on]).per(3)
    else
      @bills = Bill.introduced_house_bills.page params[:the_bills]
    end
  end

  def senate_bills
    if @user = current_user
      @voted_on_bills = @user.bills_voted_on(:senate).page(params[:voted_on]).per(3)
      @not_voted_on_bills = @user.bills_not_voted_on(:senate).page(params[:not_voted_on]).per(5)
    else
      @bills = Bill.introduced_senate_bills.page(params[:the_bills]).per(10)
    end
  end

  def legislators_districts
    @reps = Legislator.representatives.page(params[:page]).per(10)
    @bills = Bill.bill_search(params[:bill_search]).page(params[:page])
  end

end
