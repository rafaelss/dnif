# encoding: utf-8
require "riddle"

module Dnif
  extend self

  autoload :Configuration, "dnif/configuration"
  autoload :Index, "dnif/index"
  autoload :Schema, "dnif/schema"
  autoload :Document, "dnif/document"
  autoload :Indexer, "dnif/indexer"
  autoload :MultiAttribute, "dnif/multi_attribute"
  autoload :Search, "dnif/search"

  def root_path
    @root_path
  end

  def root_path=(value)
    @root_path = value
  end

  def environment
    @environment || 'development'
  end
  alias :env :environment

  def environment=(value)
    @environment = value
  end
  alias :env= :environment=

  def models_path
    @models_path
  end

  def models_path=(value)
    @models_path = value
  end

  def load_models
    models = Dir["#{self.models_path}/*.rb"]
    models.map! do |filename|
      filename = File.basename(filename, '.rb')
      filename.classify.constantize
    end
  end

  def search(query, options = {})
    options.reverse_merge!(:index => '*')

    if options[:classes]
      ids = if options[:classes].is_a?(Array)
        options[:classes].map { |name| ActiveRecord::Base.indexes.keys.index(name) }
      else
        [ActiveRecord::Base.indexes.keys.index(options[:classes])]
      end

      client.filters = [Riddle::Client::Filter.new("class_id", ids)]
    end

    results = client.query(query, options[:index])
    raise results[:error] if results[:error]

    models = {}
    results[:matches].each do |match|
      encoded_class_name = match[:attributes]["class_name"].split(',').flatten
      class_name = Dnif::MultiAttribute.decode(encoded_class_name)

      models[class_name] ||= []
      models[class_name] << (match[:doc] - encoded_class_name.sum { |c| c.to_i })
    end

    models.map do |class_name, ids|
      klass = class_name.constantize
      class_name.constantize.where("#{klass.primary_key} IN (?)", ids)
    end.flatten
  end

  def client
    searchd = Dnif::Configuration.options_for("searchd", config_path)
    if searchd["listen"]
      address, port = searchd["listen"].split(":")
    else
      address = searchd["address"] || "127.0.0.1"
      port = searchd["port"] || 3313
    end

    @client ||= Riddle::Client.new(address, port)
  end

  def config_path
    Dnif.root_path ||= File.expand_path(File.dirname("."))
    File.join(Dnif.root_path, "config/sphinx", Dnif.environment + ".erb")
  end
end

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend(Dnif::Indexer)
  ActiveRecord::Base.extend(Dnif::Search)
end
