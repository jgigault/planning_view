require 'active_support'
require 'planning_view/controller_methods.rb'
require "planning_view/version"

initializer 'planning_view' do
  ActiveSupport.on_load(:action_controller) do
    include PlanningView::Controller
  end
end
