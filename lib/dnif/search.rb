module Dnif

  def self.search(query, options = {})
    options.reverse_merge!(:index => '*')

    Dnif.root_path ||= File.expand_path(File.dirname("."))
    searchd = Dnif::Configuration.options_for("searchd", File.join(Dnif.root_path, "config/sphinx", Dnif.environment + ".erb"))
    client = Riddle::Client.new(*searchd["listen"].split(":"))

    if not options[:class].nil?
      filter_value = Dnif::MultiAttribute.encode(options[:class]).split(",").map(&:to_i)
      client.filters << Riddle::Client::Filter.new("class_id", filter_value)
    end

    results = client.query(query, options[:index])
    raise results[:error] if results[:error]

    models = results[:matches].inject({}) do |memo, match|
      class_id = match[:attributes]["class_id"].split(',').flatten
      class_name = Dnif::MultiAttribute.decode(class_id)

      memo[class_name] ||= []
      memo[class_name] << (match[:doc] - class_id.sum { |c| c.to_i })
      memo
    end

    models.map do |class_name, ids|
      class_name.constantize.find_all_by_id(ids)
    end.flatten
  end

  module Search

    def search(query)
      Dnif.search(query, :class => self.name)
    end
  end
end

ActiveRecord::Base.extend(Dnif::Search)