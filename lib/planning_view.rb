require 'planning_view/controller_methods.rb'
require "planning_view/version"

ActiveSupport.on_load(:action_controller) do
  include PlanningView::Controller
end
eerreror