# encoding: utf-8

require 'active_record'
require 'active_support'
require 'riddle'

require "dnif/configuration"
require "dnif/index_builder" # TODO remove
require "dnif/index"
require "dnif/schema"
require "dnif/document"
require "dnif/indexer"
require "dnif/multi_attribute"
require "dnif/search"

module Dnif

  def self.root_path
    @root_path
  end

  def self.root_path=(value)
    @root_path = value
  end

  def self.environment
    @environment || 'development'
  end

  def self.environment=(value)
    @environment = value
  end

  def self.models_path
    @models_path
  end

  def self.models_path=(value)
    @models_path = value
  end

  def self.load_models
    models = Dir["#{self.models_path}/*.rb"]
    models.map! do |filename|
      filename = File.basename(filename, '.rb')
      filename.classify.constantize
    end
  end
end

if defined?(Rails)
  Dnif.root_path = RAILS_ROOT
  Dnif.environment = RAILS_ENV
  Dnif.models_path = File.join(RAILS_ROOT, "app", "models")
end