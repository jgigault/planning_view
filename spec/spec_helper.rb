RSpec.configure do |config|

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.order = :random

  #c.mock_with :rspec

  #c.before(:all) do
  # for Apartment
  # Ensure that each test starts with a clean connection
  # Necessary as some tests will leak things like current_schema into the next test
  #  ActiveRecord::Base.clear_all_connections!
  #end

  config.before(:suite) do
    #DatabaseCleaner.clean_with :truncation #, {except: %w[appconfigs]}
    #DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    #DatabaseCleaner.start
  end

  config.after(:each) do
    #DatabaseCleaner.clean
  end
end