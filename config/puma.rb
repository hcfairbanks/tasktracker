threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

rails_env = ENV.fetch("RAILS_ENV") { "production" }
environment rails_env

app_dir = File.expand_path("../..", __FILE__)
directory app_dir
shared_dir = "#{app_dir}/tmp"

if %w[production staging].member?(rails_env)
  stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

  pidfile "#{shared_dir}/pids/puma.pid"
  state_path "#{shared_dir}/pids/puma.state"

  workers ENV.fetch("WEB_CONCURRENCY") { 2 }

  preload_app!

  bind "unix://#{shared_dir}/sockets/puma.sock"

  on_worker_boot do
    ActiveSupport.on_load(:active_record) do
    end
  end
elsif rails_env == "development"
  port   ENV.fetch("PORT") { 3000 }
  plugin :tmp_restart
end
