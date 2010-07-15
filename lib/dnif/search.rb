module Dnif

  def self.search(query, options = {})
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

    models = results[:matches].inject({}) do |memo, match|
      encoded_class_name = match[:attributes]["class_name"].split(',').flatten
      class_name = Dnif::MultiAttribute.decode(encoded_class_name)

      memo[class_name] ||= []
      memo[class_name] << (match[:doc] - encoded_class_name.sum { |c| c.to_i })
      memo
    end

    models.map do |class_name, ids|
      class_name.constantize.find_all_by_id(ids)
    end.flatten
  end

  def self.client
    searchd = Dnif::Configuration.options_for("searchd", config_path)
    if searchd["listen"]
      address, port = searchd["listen"].split(":")
    else
      address = searchd["address"] || "127.0.0.1"
      port = searchd["port"] || 3313
    end

    @client ||= Riddle::Client.new(address, port)
  end

  def self.config_path
    Dnif.root_path ||= File.expand_path(File.dirname("."))
    File.join(Dnif.root_path, "config/sphinx", Dnif.environment + ".erb")
  end

  module Search

    def search(query)
      Dnif.search(query, :classes => self.name)
    end
  end
end

ActiveRecord::Base.extend(Dnif::Search) if defined?(ActiveRecord::Base)