require 'active_support'
require 'fileutils'
require 'dnif'

def controller
  require 'riddle'

  root_path = Dnif.root_path || "."

  configuration = Riddle::Configuration.new
  configuration.searchd.pid_file   = "#{root_path}/log/searchd.#{Dnif.environment}.pid"
  configuration.searchd.log        = "#{root_path}/log/searchd.log"
  configuration.searchd.query_log  = "#{root_path}/log/searchd.query.log"

  Riddle::Controller.new(configuration, "#{root_path}/config/sphinx/#{Dnif.environment}.conf")
end

namespace :dnif do

  task :environment do
    if task = Rake::Task[:environment]
      task.invoke
    end
  end

  desc "Generates the configuration file needed for sphinx"
  task :configure => :environment do
    if Dnif.models_path.nil?
      puts "You need to specify where are your models (ex: Dnif.models_path = \"path/for/your/models\")"
      exit
    end

    Dnif.root_path ||= File.expand_path(File.dirname("."))
    Dnif.environment ||= "development"

    config_path = File.join(Dnif.root_path, "config/sphinx")
    if not File.exist?(config_path)
      FileUtils.mkdir_p(config_path)
    end

    base_path = File.join(config_path, Dnif.environment + ".erb")
    if not File.exist?(base_path)
      FileUtils.cp(File.dirname(__FILE__) + "/../../test/fixtures/templates/config.erb", base_path) # TODO change this path. find out how this kind of stuff is handle in others gems
    end

    Dnif.load_models
    Dnif::Configuration.generate(base_path)
  end

  desc "Generates the XML used by sphinx to create indexes"
  task :xml => :environment do
    ::ActiveRecord::Base.logger = Logger.new(StringIO.new)
    Dnif.load_models

    klass = ENV['MODEL'].constantize
    puts klass.to_sphinx
  end

  desc "Index data for sphinx"
  task :index => :environment do
    controller.index(:verbose => true)
  end

  desc "Stop sphinx daemon"
  task :stop => :environment do
    controller.stop
  end

  desc "Start sphinx daemon"
  task :start => :environment do
    controller.start
  end

  desc "Rebuild sphinx index"
  task :rebuild => [:index, :stop, :start]
end