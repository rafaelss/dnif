module Dnif
  module Indexer

    @@indexes ||= {}

    def define_index(&block)
      indexes[self.name] = Dnif::Index.new(&block)

      include InstanceMethods
    end

    def indexes
      @@indexes
    end

    def to_sphinx
      return nil if indexes.blank?

      xml = Builder::XmlMarkup.new(:indent => 2)
      xml.instruct!
      xml.sphinx(:docset) do
        schema = Schema.new(self)
        xml << schema.generate

        results = all(:conditions => indexes[self.name].conditions)
        results.each do |object|
          document = Document.new(object)
          xml << document.generate
        end
      end
      xml.target!
    end

    module InstanceMethods

      def indexes
        self.class.indexes
      end

      def index
        self.class.indexes[self.class.name]
      end

      def to_sphinx
        document = Document.new(self)
        document.generate
      end
    end
  end
end

ActiveRecord::Base.extend(Dnif::Indexer) if defined?(ActiveRecord::Base)