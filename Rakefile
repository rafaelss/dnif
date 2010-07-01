begin
  require 'jeweler'

  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "dnif"
    gemspec.summary = "dnif is the new find... for sphinx"
    gemspec.description = "dnif is a gem to index data using ActiveRecord finders, letting you index your custom methods and not your table fields "
    gemspec.email = "me@rafaelss.com"
    gemspec.homepage = "http://github.com/rafaelss/dnif"
    gemspec.authors = ["Rafael Souza"]

    gemspec.has_rdoc = false
    gemspec.files = %w(Rakefile dnif.gemspec README.rdoc) + Dir["{lib,test}/**/*"]

    gemspec.add_dependency "activerecord"
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

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.test_files = FileList.new('test/**/test_*.rb') do |list|
    list.exclude 'test/test_helper.rb'
  end
  test.libs << 'test'
  test.verbose = true
end