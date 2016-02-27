require 'action_controller/railtie'

require 'planning_view'

module RailsApp
  class Application < Rails::Application
    config.secret_key_base = 'cd999e502fa659c4872f7eca910648d85e7d750c3f71aa217ec96b05b3818e88eefca1abd83e9444ac5cf2c1ce1ff003f3d5bd58d4839f80f5f2127a4479abb4'
  end
end
