module Dnif
  class Document

    def initialize(object)
      @object = object
    end

    def generate
      xml = Builder::XmlMarkup.new(:indent => 2)
      xml.sphinx(:document, :id => document_id) do
        fields = []
        @object.indexes.values.each do |index|
          (index.fields - fields).each do |name|
            if @object.index.fields.include?(name)
              xml.tag!(name) do
                xml.cdata!(@object.send(name).to_s)
              end
            else
              xml.tag!(name, "")
            end

            fields << name
          end
        end

        xml.class_id(@object.indexes.keys.index(@object.class.name))
        xml.class_name(encoded_class_name)

        attributes = []
        @object.indexes.values.each do |index|
          index.attributes.each do |name, type|
            next if attributes.include?(name)

            if @object.index.attributes.has_key?(name)
              value = @object.send(name)

              if [:date, :datetime].include?(type)
                if value.is_a?(Date)
                  value = value.to_datetime
                end
                value = value.to_i
              end
            else
              value = ""
            end

            xml.tag!(name, value)
            attributes << name
          end
        end
      end
      xml.target!
    end

    def document_id
      @object.send(@object.class.primary_key.to_sym) + encoded_class_name.split(',').sum { |c| c.to_i }
    end

    private

      def encoded_class_name
        @encoded_class_name ||= Dnif::MultiAttribute.encode(@object.class.name)
      end
  end
end
