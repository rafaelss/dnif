# encoding: utf-8

$:.unshift(File.dirname(__FILE__) + "/../../lib/")
require 'test/unit'
require 'mocha'
require 'dnif'
require 'erb'

Dnif.root_path = File.expand_path(File.dirname(__FILE__) + "/../fixtures")

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
silence_stream(STDOUT) { load "fixtures/db/schema.rb" }

class User < ActiveRecord::Base

  define_index do
    field :name
  end
end

class TestConfiguration < Test::Unit::TestCase

  test "generate configuration from default template" do
    Tilt.expects(:register).with('erb', Tilt::ErubisTemplate)

    template = mock("Template")
    template.expects(:render).with(Dnif::Configuration).returns('output')
    Tilt.expects(:new).with("config/path.erb").returns(template)

    file = mock
    file.expects(:puts).with('output')
    File.expects(:open).with(Dnif.root_path + "/config/sphinx/development.conf", "w").yields(file)

    Dnif::Configuration.generate("config/path.erb")
  end

  test "sources should iterate over all indexed classes" do
    names = []
    classes = []
    Dnif::Configuration.sources do |name, class_name|
      names << name
      classes << class_name
    end

    assert_equal ["users_main"], names
    assert_equal ["User"], classes
  end
end