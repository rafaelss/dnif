module Dnif

  def self.search(query, options = {})
    options.reverse_merge!(:index => '*')

    client = Riddle::Client.new("127.0.0.1", 3313)

    if not options[:class].nil?
      filter_value = Dnif::MultiAttribute.encode(options[:class]).split(",").map(&:to_i)
      client.filters << Riddle::Client::Filter.new("class_id", filter_value)
    end

    results = client.query(query, options[:index])
    raise results[:error] if results[:error]

    models = results[:matches].inject({}) do |memo, match|
      class_id = match[:attributes]["class_id"]
      class_name = Dnif::MultiAttribute.decode(class_id)

      memo[class_name] ||= []
      memo[class_name] << (match[:doc] - class_id.sum { |c| c.to_i }) / ActiveRecord::Base.classes.length
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