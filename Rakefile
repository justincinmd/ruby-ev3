require "bundler/gem_tasks"

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -r ev3.rb"
end

Dir["tasks/**/*.rake"].each do |file|
  load(file)
end