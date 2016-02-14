require 'spec_helper'

class MockController #< ActionController::TestCase
  include PlanningView::Controller
end

describe 'controller', type: :controller do
  it 'works' do
    cat = Category.create
    p = Project.create category: cat, negotiation_start: Date.new(2015), negotiation_end: Date.new(2016)
    c = MockController.new
    @collection = Project.all
    c.build_planning_view_variables(start_date: Date.new(2015),
                                    end_date: Date.new(2016),
                                    timeslots: {start_attribute: :negotiation_start,
                                                end_attribute: :negotiation_end})

    expect(c.instance_variable_get('@planning_view_today')).to eq(Date.today)
  end
end