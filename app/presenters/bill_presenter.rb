class BillPresenter < BasePresenter
  presents :bill

  def bill_title
    h.content_tag(:div, bill.bill_title, id: 'bill_title')
  end

  def bill_description
    h.content_tag(:div, bill.long_title)
  end

  def bill_sponsor
    h.content_tag(:div, "Sponsored by #{h.link_to(bill.sponsor.full_name, legislator_path(bill.sponsor.id))}".html_safe) if bill.sponsor
  end

  def vote_region
    if user = current_user
      unless bill.voted_on?(user)
        h.render(partial: "vote_region", locals: {bill: bill})
      else
        h.content_tag(:div, "Voted on this bill already.")
      end
    else
       "log in to vote"
    end
  end

end
