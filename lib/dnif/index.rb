module Dnif
  class Index

    attr_reader :fields
    attr_reader :attributes
    attr_reader :conditions

    def initialize(&block)
      @fields = []
      @attributes = {}

      self.instance_eval(&block)
    end

    def field(name)
      @fields << name
    end

    def attribute(name, options)
      raise "You must specify the attribute type (:integer, :datetime, :date, :boolean, :float)" if options[:type].nil?

      @attributes[name] = options[:type]
    end

    def where(conditions)
      @conditions = conditions
    end
  end
end