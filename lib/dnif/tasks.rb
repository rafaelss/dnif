require "fileutils"

def controller
  require 'riddle'

  configuration = Riddle::Configuration.new
  configuration.searchd.pid_file   = "#{Dnif.root_path}/log/searchd.#{Dnif.environment}.pid"
  configuration.searchd.log        = "#{Dnif.root_path}/log/searchd.log"
  configuration.searchd.query_log  = "#{Dnif.root_path}/log/searchd.query.log"

  Riddle::Controller.new(configuration, "#{Dnif.root_path}/config/sphinx/#{Dnif.environment}.conf")
end

namespace :dnif do

  if !Rake::Task.task_defined?(:environment)
    desc "Set default values for Dnif"
    task :environment do
      Dnif.root_path ||= Dir.pwd
      Dnif.environment ||= "development"

      if !Dnif.models_path.nil?
        Dnif.load_models
      end
    end
  end

  desc "Generates the configuration file needed for sphinx"
  task :configure => :environment do
    if Dnif.models_path.nil?
      puts "You need to specify where are your models (ex: Dnif.models_path = \"path/for/your/models\")"
      exit
    end

    config_path = File.join(Dnif.root_path, "config/sphinx")
    if !File.exist?(config_path)
      FileUtils.mkdir_p(config_path)
    end

    base_path = File.join(config_path, Dnif.environment + ".erb")
    if !File.exist?(base_path)
      FileUtils.cp(File.dirname(__FILE__) + "/../../templates/config.erb", base_path) # TODO change this path. find out how this kind of stuff is handle in others gems
    end

    Dnif.load_models
    path = Dnif::Configuration.generate(base_path)
    puts "\n>> config generated: #{path}"
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
    puts "\n>> data indexed" # TODO show this only whether daemon is really indexed
  end

  desc "Stop sphinx daemon"
  task :stop => :environment do
    while controller.running?
      controller.stop
      sleep(1)
    end
    puts "\n>> daemon stopped" # TODO show this only whether daemon is really stopped
  end

  desc "Start sphinx daemon"
  task :start => :environment do
    controller.start
    puts "\n>> daemon started" # TODO show this only whether daemon is really started
  end

  desc "Restart sphinx daemon"
  task :restart => [ :stop, :start ]

  desc "Rebuild sphinx index"
  task :rebuild => [ :index, :restart ]
end
