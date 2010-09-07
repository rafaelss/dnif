# encoding: utf-8
require "bundler"
Bundler.require(:default)

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
end

ActiveRecord::Base.extend(Dnif::Indexer) if defined?(ActiveRecord::Base)
