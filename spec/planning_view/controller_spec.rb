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

        expect(my_controller.instance_variable_get('@planning_view_margins_start_date')).to eq(default_start_date - 10.years)
        expect(my_controller.instance_variable_get('@planning_view_margins_end_date')).to eq(default_end_date + 10.years)

        expect(my_controller.instance_variable_get('@planning_view_name')).to eq(nil)
        expect(my_controller.instance_variable_get('@planning_view_group_by')).to eq(nil)
        expect(my_controller.instance_variable_get('@planning_view_timeslots')).to eq([])
        expect(my_controller.instance_variable_get('@planning_view_expandable')).to eq(false)

        expect(my_controller.instance_variable_get('@planning_view_marker_date')).to eq(Date.today)
        expect(my_controller.instance_variable_get('@planning_view_marker_label')).to eq(I18n.t('concepts.today'))

        expect(my_controller.instance_variable_get('@planning_view_row_data_attributes')).to eq({})
      end

      context "start and end dates" do
        it "takes specified dates" do
          my_controller.build_planning_view_variables(start_date: Date.new(2015, 3, 5), end_date: Date.new(2015, 3, 24))

          expect(my_controller.instance_variable_get('@planning_view_start_date')).to eq(Date.new(2015, 3, 5))
          expect(my_controller.instance_variable_get('@planning_view_end_date')).to eq(Date.new(2015, 3, 24))
        end
      end

      context "margin time" do
        it "takes into account specified durations" do
          my_controller.build_planning_view_variables(start_date: Date.new(2015, 1, 1), end_date: Date.new(2015, 12, 31),
                                                      margin_time_before: 3.months, margin_time_after: 1.year)

          expect(my_controller.instance_variable_get('@planning_view_margins_start_date')).to eq(Date.new(2014, 10, 1))
          expect(my_controller.instance_variable_get('@planning_view_margins_end_date')).to eq(Date.new(2016, 12, 31))
        end
      end

      context "nb_of_days" do
        it "exactly counts number of days" do
          my_controller.build_planning_view_variables(start_date: Date.new(2015, 3, 5), end_date: Date.new(2015, 3, 24))

          expect(my_controller.instance_variable_get('@planning_view_nb_of_days')).to eq(20)
        end

        it "takes into account leap years" do
          my_controller.build_planning_view_variables(start_date: Date.new(2016, 1, 1), end_date: Date.new(2016, 12, 31))

          expect(my_controller.instance_variable_get('@planning_view_nb_of_days')).to eq(366)
        end
      end

      context "margin nb_of_days" do
        it "exactly counts number of days" do
          my_controller.build_planning_view_variables(start_date: Date.new(2015, 3, 5), end_date: Date.new(2015, 3, 24),
                                                      margin_time_before: 3.months, margin_time_after: 1.year)

          expect(my_controller.instance_variable_get('@planning_view_margins_nb_of_days')).to eq(476)
        end
      end
    end

    context "" do
      before :each do
        cat = Category.create
        p = Project.create category: cat, negotiation_start: Date.new(2015), negotiation_end: Date.new(2016)
        @collection = Project.all
      end
    end

    context "standard errors" do
      it "raises when @collection is nil" do
        expect {
          my_controller.build_planning_view_variables
        }.to raise_error PlanningView::Controller::NoCollectionError
      end

      context "with collection" do
        before :each do
          my_controller.collection = []
        end

        context "dates" do
          it "raises when end_date is before start_date" do
            expect {
              my_controller.build_planning_view_variables(start_date: Date.new(2015, 1, 1), end_date: Date.new(2014, 1, 1))
            }.to raise_error PlanningView::Controller::EndDateBeforeOrEqualToStartDateError
          end

          it "raises when end_date is equal to start_date" do
            expect {
              my_controller.build_planning_view_variables(start_date: Date.new(2015, 1, 1), end_date: Date.new(2015, 1, 1))
            }.to raise_error PlanningView::Controller::EndDateBeforeOrEqualToStartDateError
          end
        end

        context "margins" do
          it "raises when margin time before is negative" do
            expect {
              my_controller.build_planning_view_variables(margin_time_before: -(5.years))
            }.to raise_error PlanningView::Controller::NegativeMarginError
          end

          it "raises when margin time after is negative" do
            expect {
              my_controller.build_planning_view_variables(margin_time_after: -(5.years))
            }.to raise_error PlanningView::Controller::NegativeMarginError
          end
        end
      end
    end

  end

end