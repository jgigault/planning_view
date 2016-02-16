require 'active_support/core_ext/string/output_safety'

module PlanningView

  module Controller

    class NoCollectionError < StandardError; end
    class EndDateBeforeOrEqualToStartDateError < StandardError; end
    class NegativeMarginError < StandardError; end

    def build_planning_view_variables(start_date: Date.today.beginning_of_year,
                                        end_date: Date.today.end_of_year,
                                       timeslots: [],
                              margin_time_before: 10.years,
                               margin_time_after: 10.years,
                                          marker: {date: Date.today, label: I18n.t('concepts.today')},
                                    default_zoom: 12,
                                        group_by: nil,
                                  highlight_name: nil,
                                      expandable: false,
                             row_data_attributes: {})

      raise NoCollectionError if @collection == nil
      raise EndDateBeforeOrEqualToStartDateError if end_date <= start_date
      raise NegativeMarginError if margin_time_before < 0 || margin_time_after < 0

      @planning_view_marker_date = marker[:date]
      @planning_view_marker_label = marker[:label]
      @planning_view_group_by = group_by
      @planning_view_timeslots = timeslots
      @planning_view_expandable = expandable
      @planning_view_highlight_name = highlight_name
      @planning_view_row_data_attributes = row_data_attributes
      @planning_view_default_zoom = default_zoom

      @planning_view_start_date = start_date
      @planning_view_end_date = end_date
      @planning_view_nb_of_days = end_date - start_date + 1

      @planning_view_margins_start_date = start_date - margin_time_before
      @planning_view_margins_end_date = end_date + margin_time_after
      @planning_view_margins_nb_of_days = @planning_view_margins_end_date - @planning_view_margins_start_date + 1

      @planning_view_width = (@planning_view_nb_of_days * 100 / @planning_view_margins_nb_of_days).to_f
      @planning_view_x = ((start_date - @planning_view_margins_start_date + 1) * 100 / @planning_view_margins_nb_of_days).to_f
      @planning_view_marker_x = ((@planning_view_marker_date - @planning_view_margins_start_date + 1) * 100 / @planning_view_margins_nb_of_days).to_f

      @planning_view_months = []

      current_year = 0
      month = @planning_view_start_date.beginning_of_month
      while month < @planning_view_end_date do
        start_month_x = ((month - @planning_view_margins_start_date + 1) * 100 / @planning_view_margins_nb_of_days).to_f

        @planning_view_months << {
          date: month,
          name: "#{'<span>' if current_year != month.year}#{I18n.t("date.abbr_month_names")[month.month]}#{"<br /></span><span>#{month.year}</span>".html_safe if current_year != month.year}",
          x: start_month_x,
          width: (((month + 1.month) - month) * 100 / @planning_view_margins_nb_of_days).to_f,
          highlight: (month >= start_date && month < end_date)
        }

        current_year = month.year if current_year != month.year
        month = month + 1.month
      end

      nb_of_years = ((@planning_view_margins_end_date - @planning_view_margins_start_date + 1) / 365).to_f
      @planning_view_available_zoom = {
        60 => (100.0 / 66  * nb_of_years * 12).to_i,
        24 => (100.0 / 29  * nb_of_years * 12).to_i,
        12 => (100.0 / 15  * nb_of_years * 12).to_i,
        6  => (100.0 / 7   * nb_of_years * 12).to_i,
        3  => (100.0 / 3.5 * nb_of_years * 12).to_i
      }
    end

  end

end
