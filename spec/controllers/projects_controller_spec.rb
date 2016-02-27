require 'rails_helper'
require 'rails_app/app/controllers/projects_controller'

describe ProjectsController, type: :controller do
  render_views

  it "works" do
    get :planning
    expect(response).to have_http_status 200
  end
end