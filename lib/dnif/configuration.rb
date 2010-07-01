require 'fileutils'
require 'tilt'
require 'dnif'

module Dnif

  class Configuration

    def self.generate(config_path)
      Tilt.register 'erb', Tilt::ErubisTemplate

      template = Tilt.new(config_path)
      output = template.render(self)

      # TODO turn "db/sphinx" and "config/sphinx" configurable
      FileUtils.mkdir_p(File.join(Dnif.root_path, "db", "sphinx", Dnif.environment))
      File.open(Dnif.root_path + "/config/sphinx/" + Dnif.environment + ".conf", "w") do |f|
        f.puts output
      end
    end

    def self.sources
      classes = ActiveRecord::Base.classes.keys
      classes.each do |class_name|
        name = class_name.underscore.pluralize + "_main"
        yield name, class_name
      end
    end
  end
end