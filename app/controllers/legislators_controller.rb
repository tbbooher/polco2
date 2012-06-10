class LegislatorsController < InheritedResources::Base
  def show
    super
    @latest_votes = @legislator.latest_votes.page(params[:page])
  end
end
