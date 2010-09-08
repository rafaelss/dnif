require "dnif"
require "rails"

module Dnif
  class Railtie < Rails::Railtie

    config.to_prepare do
      Dnif.root_path = Rails.root
      Dnif.environment = Rails.env
      Dnif.models_path = File.join(Rails.root, "app", "models")
    end

    rake_tasks do
      load "dnif/tasks.rb"
    end
  end
end
