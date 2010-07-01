# encoding: utf-8
require 'test_helper'
require 'erb'

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

    assert_equal ["users_main", "people_main", "orders_main", "notes_main"], names
    assert_equal ["User", "Person", "Order", "Note"], classes
  end
end