preload_app!

min_threads = Integer(ENV['PUMA_MIN_THREADS'] || 0) # puma's default
max_threads = Integer(ENV['PUMA_MAX_THREADS'] || 8) # puma's default

threads min_threads, max_threads
workers Integer(ENV['PUMA_WORKER_COUNT'] || 2 ) # ±256MB/process

rackup      DefaultRackup

port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    config = ActiveRecord::Base.configurations[Rails.env] || Rails.application.config.database_configuration[Rails.env]
    config['pool'] = ENV['DB_POOL'] || max_threads
    ActiveRecord::Base.establish_connection(config)
  end
end
