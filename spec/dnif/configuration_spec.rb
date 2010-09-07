# encoding: utf-8
require 'test_helper'
require 'erb'

class TestConfiguration < Test::Unit::TestCase

  test "generate configuration from default template" do
    File.expects(:read).with("config/path.erb").returns("configurations")

    template = mock("Template")
    template.expects(:result).returns('output')
    ERB.expects(:new).with("configurations").returns(template)

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

  test ".options_for" do
    client = Dnif::Configuration.options_for("searchd", File.join(Dnif.root_path, "templates", "config.erb"))
    assert client.is_a?(Hash)
  end
end