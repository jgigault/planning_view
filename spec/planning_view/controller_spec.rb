require 'spec_helper'

class MockController #< ActionController::TestCase
  include PlanningView::Controller
end

describe 'controller' do
  it 'works' do
    cat = Category.create
    p = Project.create category: cat, negotiation_start: Date.new(2015), negotiation_end: Date.new(2016)
    c = MockController.new
    @collection = Project.all

    start_date = Date.new(2015)
    end_date = Date.new(2015, 12, 31)
    c.build_planning_view_variables(start_date: start_date,
                                    end_date: end_date,
                                    timeslots: {start_attribute: :negotiation_start,
                                                end_attribute: :negotiation_end})

    expect(c.instance_variable_get('@planning_view_today')).to eq(Date.today)
    expect(c.instance_variable_get('@planning_view_highlight_start_date')).to eq(start_date)
    expect(c.instance_variable_get('@planning_view_highlight_end_date')).to eq(end_date)
    expect(c.instance_variable_get('@planning_view_highlight_nb_of_days')).to eq(365)
    expect(c.instance_variable_get('@planning_view_highlight_name')).to eq(nil)
    expect(c.instance_variable_get('@planning_view_group_by')).to eq(:none)
  end
end