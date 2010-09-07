require "bundler"
Bundler.require(:rake)

begin
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "dnif"
    gemspec.summary = "dnif is the new find... for sphinx"
    gemspec.description = "dnif is a gem to index data using ActiveRecord finders, letting you index your custom methods and not only your table fields"
    gemspec.email = "me@rafaelss.com"
    gemspec.homepage = "http://github.com/rafaelss/dnif"
    gemspec.authors = ["Rafael Souza"]

    gemspec.has_rdoc = false
    gemspec.files = %w(Rakefile dnif.gemspec README.rdoc) + Dir["{lib,test}/**/*"]

    gemspec.add_dependency "activerecord"
    gemspec.add_dependency "activesupport"
    gemspec.add_dependency "riddle"
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

desc "Generate gemspec and build gem"
task :build_gem do
  Rake::Task["gemspec"].invoke
  Rake::Task["build"].invoke
end

Jeweler::GemcutterTasks.new

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)
