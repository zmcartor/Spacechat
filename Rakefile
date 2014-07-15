require 'rake'
require 'rake/testtask'
require "sinatra/activerecord/rake"
require_relative "./app"

desc "Start AR console"
task(:console) do
  require 'irb'
  puts "Loading Spacechat Console ~~~>[o]>"
  ARGV.clear
  IRB.start
end

Rake::TestTask.new do |t|
   t.test_files = Dir.glob('tests/**/*_test.rb')
   puts Dir.glob('tests/**/*_test.rb')
end
task(default: :test)
