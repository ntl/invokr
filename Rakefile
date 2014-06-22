require "bundler/gem_tasks"

desc "Update ctags"
task :ctags do
  `ctags -R --languages=Ruby --totals -f tags`
end

desc "Test against all ruby versions"
task :rbenv_suite do
  %w(2.1.2 2.0.0-p481 1.9.3-p545).each do |ruby_ver|
    child_pid = fork do
      ruby_path = File.join ENV['RBENV_ROOT'], 'shims/ruby'
      cmd = "#{ruby_path} bin/test_runner ; echo"
      puts "Testing #{ruby_ver}"
      env = { 'RBENV_VERSION' => ruby_ver }
      exec env, cmd
    end
    Process.wait2 child_pid
  end
end

task :default => :rbenv_suite
