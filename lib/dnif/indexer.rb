module Dnif
  module Indexer

    def define_index(&block)
      classes[self.name] = IndexBuilder.new(self, &block)
      classes[self.name]

      include InstanceMethods
    end

    def classes
      @@classes ||= ActiveSupport::OrderedHash.new
    end

    def to_sphinx
      return nil if classes.blank?

      returning('') do |xml|
        builder = classes[self.name]
        results = all(:conditions => builder.conditions)

        xml << "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<sphinx:docset>\n"

        xml << "<sphinx:schema>\n"
        builder.fields.each do |name|
          xml << "  <sphinx:field name=\"#{name}\"/>\n"
        end

        xml << "  <sphinx:attr name=\"class_id\" type=\"multi\"/>\n"
        builder.attributes.each do |name, type|
          xml << "  <sphinx:attr name=\"#{name}\" "

          case type
          when :integer
            xml << "type=\"int\""
          when :date, :datetime
            xml << "type=\"timestamp\""
          when :boolean
            xml << "type=\"bool\""
          when :float
            xml << "type=\"float\""
          end

          xml << "/>\n"
        end

        xml << "</sphinx:schema>\n"

        results.each do |object|
          xml << object.to_sphinx
        end
        xml << "</sphinx:docset>"
      end
    end

    module InstanceMethods

      def to_sphinx
        builder = ActiveRecord::Base.classes[self.class.name]
        if not builder.nil?
          class_id = Dnif::MultiAttribute.encode(self.class.name)
          sphinx_id = id * ActiveRecord::Base.classes.length + (class_id.split(',').sum { |c| c.to_i })
          xml = "<sphinx:document id=\"#{sphinx_id}\">\n"

          builder.fields.each do |field|
            xml << "  <#{field}><![CDATA[[#{send(field)}]]></#{field}>\n"
          end

          xml << "  <class_id>#{class_id}</class_id>\n"

          builder.attributes.each do |name, type|
            value = send(name)

            if [:date, :datetime].include?(builder.attributes[name])
              if value.is_a?(Date)
                value = value.to_datetime
              end

              value = value.to_i
            end

            xml << "  <#{name}>#{value}</#{name}>\n"
          end

          xml << "</sphinx:document>\n"
        end
      end
    end
  end
end

ActiveRecord::Base.extend(Dnif::Indexer)