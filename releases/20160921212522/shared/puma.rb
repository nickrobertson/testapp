#!/usr/bin/env puma

directory '/home/nick/apps/testapp/current'
rackup "/home/nick/apps/testapp/current/config.ru"
environment 'production'

pidfile "/home/nick/apps/testapp/shared/tmp/pids/puma.pid"
state_path "/home/nick/apps/testapp/shared/tmp/pids/puma.state"
stdout_redirect '/home/nick/apps/testapp/current/log/puma.error.log', '/home/nick/apps/testapp/current/log/puma.access.log', true


threads 4,16

bind 'unix:///home/nick/apps/testapp/shared/tmp/sockets/testapp-puma.sock'

workers 0



preload_app!


on_restart do
  puts 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = "/home/nick/apps/testapp/current/Gemfile"
end


on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

