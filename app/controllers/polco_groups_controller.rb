class PolcoGroupsController < InheritedResources::Base

  def index
    # scope :states, where(type: :state)
    # scope :districts, where(type: :district).desc(:member_count)
    # scope :customs, where(type: :custom)
    @states = PolcoGroup.states.page params[:page_states]
    @districts = PolcoGroup.districts.page params[:page_districts]
    @customs = PolcoGroup.customs.page params[:page_customs]
    super
  end

  def manage_groups
    @user = current_user
    # TODO - this should be optimized for Mongoid
    #@custom_groups_json_data = @user.custom_groups.select{|s| s.type == :custom}.map{|g| {:id => g.id, :name => g.name}}.to_json
    #@followed_groups_states = @user.followed_groups.select{|s| s.type == :state}.map{|g| {:id => g.id, :name => g.name}}.to_json
    #@followed_groups_districts = @user.followed_groups.select{|s| s.type == :district}.map{|g| {:id => g.id, :name => g.name}}.to_json
    #@followed_groups_custom = @user.followed_groups.select{|s| s.type == :custom}.map{|g| {:id => g.id, :name => g.name}}.to_json
    #@custom_groups = PolcoGroup.customs
  end

  private

  def prep_format(list)
    # to json
    list.map{|g| {:id => g.id, :name => g.name}}
  end
end
