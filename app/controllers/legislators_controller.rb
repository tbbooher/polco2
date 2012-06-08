class LegislatorsController < InheritedResources::Base
  def show
    super
    @latest_votes = @legislator.latest_votes.paginate(params[:page]).per(10)
  end
end
