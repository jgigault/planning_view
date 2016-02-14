require 'planning_view'
require 'active_record'
#require 'action_controller'
require 'database_cleaner'
require 'pry-rails'

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

load File.dirname(__FILE__) + '/support/schema.rb'
require File.dirname(__FILE__) + '/support/models.rb'

RSpec.configure do |c|

  #c.mock_with :rspec

  #c.before(:all) do
    # for Apartment
    # Ensure that each test starts with a clean connection
    # Necessary as some tests will leak things like current_schema into the next test
  #  ActiveRecord::Base.clear_all_connections!
  #end

  c.before(:suite) do
    DatabaseCleaner.clean_with :truncation #, {except: %w[appconfigs]}
    DatabaseCleaner.strategy = :transaction
  end

  c.before(:each) do
    DatabaseCleaner.start
  end

  c.after(:each) do
    DatabaseCleaner.clean
  end
end
