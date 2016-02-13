module PlanningView

  module Controller

    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def build_planning_view_variables(today: Date.today, start_date:, end_date:, padding_time: 10, default_zoom: 12, group_by: :none, timeslots:, expandable: false, highlight_name: nil, data_attributes: {})
        @planning_view_today = today
        @planning_view_group_by = group_by.to_sym
        @planning_view_timeslots = timeslots
        @planning_view_expandable = expandable
        @planning_view_highlight_name = highlight_name
        @planning_view_data_attributes = data_attributes
        @planning_view_default_zoom = default_zoom

        @planning_view_highlight_start_date = start_date
        @planning_view_highlight_end_date = end_date
        @planning_view_highlight_nb_of_days = end_date - start_date + 1

        @planning_view_start_date = start_date - padding_time.years
        @planning_view_end_date = end_date + padding_time.years
        @planning_view_nb_of_days = @planning_view_end_date - @planning_view_start_date + 1

        @planning_view_highlight_width = (@planning_view_highlight_nb_of_days * 100 / @planning_view_nb_of_days).to_f
        @planning_view_highlight_x = ((start_date - @planning_view_start_date + 1) * 100 / @planning_view_nb_of_days).to_f
        @planning_view_today_x = ((@planning_view_today - @planning_view_start_date + 1) * 100 / @planning_view_nb_of_days).to_f

        @planning_view_months = []

        current_year = 0
        month = @planning_view_start_date.beginning_of_month
        while month < @planning_view_end_date do
          start_month_x = ((month - @planning_view_start_date + 1) * 100 / @planning_view_nb_of_days).to_f

          @planning_view_months << {
            date: month,
            name: "#{'<span>' if current_year != month.year}#{I18n.t("date.abbr_month_names")[month.month]}#{"<br /></span>#{month.year}".html_safe if current_year != month.year}",
            x: start_month_x,
            width: (((month + 1.month) - month) * 100 / @planning_view_nb_of_days).to_f,
            highlight: (month >= start_date && month < end_date)
          }

          current_year = month.year if current_year != month.year
          month = month + 1.month
        end

        nb_of_years = padding_time * 2 + 1
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

end
