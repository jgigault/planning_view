require 'spec_helper'

class MockController #< ActionController::TestCase
  attr_accessor :collection
  include PlanningView::Controller
end

describe 'controller' do

  let(:start_date_2015) {Date.new(2015, 1, 1)}
  let(:end_date_2015)   {Date.new(2015, 12, 31)}
  let(:my_controller)   {MockController.new}

  context 'build_planning_view_variables' do

    context 'variables' do
      before :each do
        my_controller.collection = []
      end

      it 'sets default values' do
        my_controller.build_planning_view_variables

        default_start_date = Date.today.beginning_of_year
        default_end_date = Date.today.end_of_year

        expect(my_controller.instance_variable_get('@planning_view_start_date')).to eq(default_start_date)
        expect(my_controller.instance_variable_get('@planning_view_end_date')).to eq(default_end_date)
        expect(my_controller.instance_variable_get('@planning_view_nb_of_days')).to eq(default_end_date - default_start_date + 1)

        expect(my_controller.instance_variable_get('@planning_view_margins_start_date')).to eq(default_start_date - 10.years)
        expect(my_controller.instance_variable_get('@planning_view_margins_end_date')).to eq(default_end_date + 10.years)
        expect(my_controller.instance_variable_get('@planning_view_margins_nb_of_days')).to eq((default_end_date + 10.years) - (default_start_date - 10.years) + 1)

        expect(my_controller.instance_variable_get('@planning_view_name')).to eq(nil)
        expect(my_controller.instance_variable_get('@planning_view_group_by')).to eq(nil)
        expect(my_controller.instance_variable_get('@planning_view_timeslots')).to eq([])
        expect(my_controller.instance_variable_get('@planning_view_expandable')).to eq(false)

        expect(my_controller.instance_variable_get('@planning_view_marker_date')).to eq(Date.today)
        expect(my_controller.instance_variable_get('@planning_view_marker_label')).to eq(I18n.t('concepts.today'))

        expect(my_controller.instance_variable_get('@planning_view_row_data_attributes')).to eq({})
      end
    end

    context "" do
      before :each do
        cat = Category.create
        p = Project.create category: cat, negotiation_start: Date.new(2015), negotiation_end: Date.new(2016)
        @collection = Project.all
      end
    end

    context "validation" do
      it "needs @collection" do
        expect {
          my_controller.build_planning_view_variables
        }.to raise_error PlanningView::Controller::NoCollectionError
      end
    end

  end

end