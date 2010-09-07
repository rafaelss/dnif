# encoding: utf-8
require 'test_helper'

class TestSchema < Test::Unit::TestCase

  test ".generate" do
    schema = Dnif::Schema.new(User)
    expected = File.read(File.dirname(__FILE__) + "/../fixtures/sphinx_4.xml")
    assert_equal expected, schema.generate
  end
end