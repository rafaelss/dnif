$:.unshift(File.dirname(__FILE__) + "/lib")
require 'dnif/tasks'

namespace :test do

  namespace :dnif do

    task :xml do
      require File.dirname(__FILE__) + "/test/fixtures/models"
      ::ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
      ::ActiveRecord::Base.logger = Logger.new(StringIO.new)
      silence_stream(STDOUT) { load "test/fixtures/db/schema.rb" }

      Post.create!(:title => "My First Post", :published_at => DateTime.now, :draft => false)
      Post.create!(:title => "My Second Post", :published_at => DateTime.now, :draft => true)

      klass = ENV['MODEL'].constantize
      puts klass.to_sphinx
    end
  end
end