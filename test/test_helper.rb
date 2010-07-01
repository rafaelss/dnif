# encoding: utf-8

# $:.unshift(File.dirname(__FILE__) + "/../../lib/")

require "test/unit"
require "mocha"
require "active_record"

$:.unshift(File.dirname(__FILE__) + '/../lib')
require "dnif"

Dnif.root_path = File.expand_path(File.dirname(__FILE__) + "/fixtures")

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
silence_stream(STDOUT) { load "fixtures/db/schema.rb" }

class Post

  extend Dnif::Search
end

class Comment

  extend Dnif::Search
end

class User < ActiveRecord::Base

  define_index do
    field :name
  end
end

class Category < ActiveRecord::Base
end

class Property < ActiveRecord::Base
end

class Person < ActiveRecord::Base

  define_index do
    field :full_name
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end

class Order < ActiveRecord::Base

  define_index do
    field :buyer

    where ["ordered_at >= ?", 2.months.ago]
  end
end

class Note < ActiveRecord::Base

  define_index do
    attribute :clicked, :type => :integer
    attribute :published_at, :type => :datetime
    attribute :expire_at, :type => :date
    attribute :active, :type => :boolean
    attribute :points, :type => :float
  end
end