class ApplicationController < ActionController::Base
  before_filter :prepend_view_paths

  def prepend_view_paths
    prepend_view_path "../../app/views/"
  end
end
