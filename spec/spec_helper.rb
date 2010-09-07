# encoding: utf-8
require "bundler"
Bundler.require(:default, :development)

$:.unshift(File.dirname(__FILE__) + '/../lib')
require "dnif"

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f }

RSpec.configure do |config|
  config.mock_with :rspec

  config.before(:suite) do
    Dnif.root_path = File.expand_path(File.dirname(__FILE__) + "/fixtures")

    ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
    silence_stream(STDOUT) { load "fixtures/db/schema.rb" }

    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
