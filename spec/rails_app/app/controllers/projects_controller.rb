require File.expand_path('../application_controller', __FILE__)
require File.expand_path('../../../../../lib/planning_view', __FILE__)

class ProjectsController < ApplicationController
  include PlanningView::Controller

  # for tests
  attr_accessor :disable_collection
  attr_accessor :start_date
  attr_accessor :end_date
  attr_accessor :additional_time_before
  attr_accessor :additional_time_after

  def planning
    @collection = Project.all.order(:category_id) unless disable_collection

    params = {group_by: :category, expandable: true, timeslots: [{end_attribute: :negotiation_end, start_attribute: :negotiation_start}, {end_attribute: :negotiation_end, start_attribute: :negotiation_start, visible: true}]}
    params[:start_date] = start_date if start_date
    params[:end_date] = end_date if end_date
    params[:additional_time_before] = additional_time_before if additional_time_before
    params[:additional_time_after] = additional_time_after if additional_time_after

    build_planning_view_variables params
  end
end
