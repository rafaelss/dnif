require 'fileutils'
require 'tilt'
require 'dnif'

module Dnif

  class Configuration

    def self.generate(config_path)
      template = ERB.new(File.read(config_path))
      output = template.result(binding)

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

    # Code extracted from Ultrasphinx
    # Configuration file parser.
    def self.options_for(heading, path)
      # Evaluate ERB
      template = ERB.new(File.open(path) {|f| f.read})
      contents = template.result(binding)

      # Find the correct heading.
      section = contents[/^#{heading.gsub('/', '__')}\s*?\{(.*?)\}/m, 1]

      if section
        # Strip comments and leading/trailing whitespace
        section.gsub!(/^\s*(.*?)\s*(?:#.*)?$/, '\1')

        # Convert to a hash
        returning({}) do |options|
          lines = section.split(/\n+/)
          while line = lines.shift
            if line =~ /(.*?)\s*=\s*(.*)/
              key, value = $1, [$2]
              value << (line = lines.shift) while line =~ /\\$/
              options[key] = value.join("\n    ")
            end
          end
        end
      else
        # XXX Is it safe to raise here?
        puts "warning; heading #{heading} not found in #{path}; it may be corrupted. "
        {}    
      end    
    end
  end
end