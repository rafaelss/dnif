require "bundler"
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require "jeweler"

$LOAD_PATH.unshift('lib')
require "dnif/version"

Jeweler::Tasks.new do |gemspec|
  gemspec.name = "dnif"
  gemspec.version = Dnif::Version::STRING
  gemspec.summary = "dnif is the new find... for sphinx"
  gemspec.description = "dnif is a gem to index data using ActiveRecord finders, letting you index your custom methods and not only your table fields"
  gemspec.email = "me@rafaelss.com"
  gemspec.homepage = "http://github.com/rafaelss/dnif"
  gemspec.authors = ["Rafael Souza"]
  gemspec.has_rdoc = false
  gemspec.files.include %w(.gitignore .rspec templates/config.erb)
end

Jeweler::GemcutterTasks.new

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)
