require 'rails_helper'
require 'rails_app/app/controllers/projects_controller'

describe ProjectsController, type: :controller do

  let(:date_beginning_of_year) {Date.today.beginning_of_year}
  let(:date_end_of_year) {Date.today.end_of_year}

  it "works" do
    get :planning
    expect(response).to have_http_status 200
  end

  context "build planning view variables" do
    render_views false

    it 'assigns with default values' do
      get :planning
      expect(assigns(:planning_view_start_date)).to eq date_beginning_of_year
      expect(assigns(:planning_view_end_date)).to eq date_end_of_year
      expect(assigns(:planning_view_additional_time_start_date)).to eq(date_beginning_of_year - 10.years)
      expect(assigns(:planning_view_additional_time_end_date)).to eq(date_end_of_year + 10.years)
      expect(assigns(:planning_view_name)).to eq(nil)
      expect(assigns(:planning_view_group_by)).to eq(nil)
      expect(assigns(:planning_view_timeslots)).to eq([])
      expect(assigns(:planning_view_expandable)).to eq(false)
      expect(assigns(:planning_view_marker_date)).to eq(Date.today)
      expect(assigns(:planning_view_marker_label)).to eq(I18n.t('concepts.today'))
      expect(assigns(:planning_view_row_data_attributes)).to eq({})
    end

    context "start and end dates" do
      it 'assigns with specified dates' do
        controller.start_date = start_date = Date.new(2015, 3, 5)
        controller.end_date = end_date = Date.new(2015, 3, 24)

        get :planning
        expect(assigns(:planning_view_start_date)).to eq start_date
        expect(assigns(:planning_view_end_date)).to eq end_date
      end
    end

    context "additional time" do
      it 'takes into account specified durations' do
        controller.additional_time_before = additional_time_before = 3.months
        controller.additional_time_after = additional_time_after = 1.year

        get :planning
        expect(assigns(:planning_view_additional_time_start_date)).to eq date_beginning_of_year - additional_time_before
        expect(assigns(:planning_view_additional_time_end_date)).to eq date_end_of_year + additional_time_after
      end
    end

    context "nb_of_days" do
      context "between start and end date" do
        it 'exactly counts number of days' do
          controller.start_date = Date.new(2015, 3, 5)
          controller.end_date = Date.new(2015, 3, 24)

          get :planning
          expect(assigns(:planning_view_nb_of_days)).to eq 20
        end

        it 'takes into account leap years' do
          controller.start_date = Date.new(2016, 1, 1)
          controller.end_date = Date.new(2016, 12, 31)

          get :planning
          expect(assigns(:planning_view_nb_of_days)).to eq 366
        end
      end

      context "between additional before and after time" do
        it 'exactly counts number of days' do
          controller.start_date = Date.new(2015, 3, 5)
          controller.end_date = Date.new(2015, 3, 24)
          controller.additional_time_before = 3.months
          controller.additional_time_after = 1.year

          get :planning
          expect(assigns(:planning_view_additional_time_nb_of_days)).to eq 476
        end
      end
    end
  end

  context "standard errors" do
    render_views false

    context "collection" do
      it 'raises when nil' do
        controller.disable_collection = true

        expect {
          get :planning
        }.to raise_error PlanningView::Controller::NoCollectionError
      end
    end

    context "dates" do
      it 'raises when end_date is before start_date' do
        controller.start_date = Date.new(2015, 1, 1)
        controller.end_date = Date.new(2014, 1, 1)

        expect {
          get :planning
        }.to raise_error PlanningView::Controller::EndDateBeforeOrEqualToStartDateError
      end

      it 'raises when end_date is equal to start_date' do
        controller.start_date = Date.new(2015, 1, 1)
        controller.end_date = Date.new(2015, 1, 1)

        expect {
          get :planning
        }.to raise_error PlanningView::Controller::EndDateBeforeOrEqualToStartDateError
      end
    end

    context "additional time" do
      it 'raises when additional before time is negative' do
        controller.additional_time_before = -(5.years)

        expect {
          get :planning
        }.to raise_error PlanningView::Controller::NegativeAdditionalTimeError
      end

      it 'raises when additional after time is negative' do
        controller.additional_time_after = -(5.years)

        expect {
          get :planning
        }.to raise_error PlanningView::Controller::NegativeAdditionalTimeError
      end
    end
  end
end