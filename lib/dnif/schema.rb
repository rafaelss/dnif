module Dnif
  class Schema

    def initialize(klass)
      @klass = klass
    end

    def generate
      xml = Builder::XmlMarkup.new(:indent => 2)
      xml.sphinx(:schema) do
        # fields = @klass.indexes[@klass.name].fields.map do |name|
        #   xml.sphinx(:field, :name => name)
        #   name
        # end
        # 
        # attributes = @klass.indexes[@klass.name].attributes.map do |name, type|
        #   xml.sphinx(:attr, :name => name, :type => attribute_type(type))
        #   name
        # end

        fields = []
        @klass.indexes.values.each do |index|
          (index.fields - fields).each do |name|
            xml.sphinx(:field, :name => name)
            fields << name
          end
        end

        xml.sphinx(:attr, :name => "class_id", :type => "multi")

        attributes = []
        @klass.indexes.values.each do |index|
          index.attributes.each do |name, type|
            if not attributes.include?(name)
              xml.sphinx(:attr, :name => name, :type => attribute_type(type))
              attributes << name
            end
          end
        end
      end
      xml.target!
    end

    private

    def attribute_type(type)
      case type
      when :integer
        "int"
      when :date, :datetime
        "timestamp"
      when :boolean
        "bool"
      when :float
        "float"
      end
    end
  end
end