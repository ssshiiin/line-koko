workers ENV.fetch("WEB_CONCURRENCY") { 2 }

preload_app!


on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end