require 'rails_app/app/controllers/application_controller'

class ProjectsController < ApplicationController
  attr_accessor :collection
  include PlanningView::Controller

  def planning
    @collection = Project.all
    build_planning_view_variables
    render partial: 'planning_view/planning_view'
  end
end
