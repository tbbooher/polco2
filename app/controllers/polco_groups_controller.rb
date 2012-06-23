class PolcoGroupsController < InheritedResources::Base

  def manage_groups
    @user = current_user
    # TODO - this should be optimized for Mongoid
    @joined_groups_json_data = @user.joined_groups.select{|s| s.type == :custom}.map{|g| {:id => g.id, :name => g.name}}.to_json
    @followed_groups_states = @user.followed_groups.select{|s| s.type == :state}.map{|g| {:id => g.id, :name => g.name}}.to_json
    @followed_groups_districts = @user.followed_groups.select{|s| s.type == :district}.map{|g| {:id => g.id, :name => g.name}}.to_json
    @followed_groups_custom = @user.followed_groups.select{|s| s.type == :custom}.map{|g| {:id => g.id, :name => g.name}}.to_json
    @custom_groups = PolcoGroup.customs
  end

  private

  def prep_format(list)
    # to json
    list.map{|g| {:id => g.id, :name => g.name}}
  end
end
