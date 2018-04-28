# frozen_string_literal: true

worker_processes Integer(ENV['WEB_CONCURRENCY'] || 3)

timeout 30

working_directory (ENV['STACK_PATH']).to_s

pid '/tmp/web_server.pid'

# In dev we don't run daemonized
if ENV['RAILS_ENV'] == 'development'
  listen ENV['PORT']
else
  stderr_path "#{ENV['STACK_PATH']}/log/unicorn.stderr.log"
  stdout_path "#{ENV['STACK_PATH']}/log/unicorn.stdout.log"
  listen '/tmp/web_server.sock', backlog: 64
end

preload_app true

GC.respond_to?(:copy_on_write_friendly=) &&
  GC.copy_on_write_friendly = true

check_client_connection false

before_fork do |server, _worker|
  old_pid = '/tmp/web_server.pid.oldbin'
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end

  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |_server, _worker|
  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.establish_connection
end
