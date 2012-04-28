module SpecDataHelper

  #def cleanup_database
  #  begin
  #    User.unscoped.delete_all
  #    Bill.unscoped.delete_all
  #    Legislator.unscoped.delete_all
  #  rescue => e
  #    puts "*** ERROR CLEANING UP DATABASE -- #{e.inspect}"
  #  end
  #end

  def log_in_as(name,email)
    visit "/users/sign_in"
    fill_in("name", :with => name)
    fill_in("email", :with => email)
    click_button('')
  end

end