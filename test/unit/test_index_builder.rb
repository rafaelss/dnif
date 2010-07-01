# encoding: utf-8

$:.unshift(File.dirname(__FILE__) + "/../../lib/")
require 'test/unit'
require 'dnif'

class TestIndexBuilder < Test::Unit::TestCase

  test "object" do
    instance = Object.new
    assert_equal instance, Dnif::IndexBuilder.new(instance, & proc {}).instance_variable_get("@object")
  end

  test "fields" do
    builder = Dnif::IndexBuilder.new(Object.new, & proc {})
    builder.field(:first_name)
    builder.field(:last_name)

    assert_equal [:first_name, :last_name], builder.fields
  end

  test "attribute" do
    builder = Dnif::IndexBuilder.new(Object.new, & proc {})
    builder.attribute(:ordered_at, :type => :datetime)

    expected =  { :ordered_at => :datetime }
    assert_equal expected, builder.attributes
  end

  test "where" do
    builder = Dnif::IndexBuilder.new(Object.new, & proc {})
    builder.where("status = 'active'")

    assert_equal "status = 'active'", builder.conditions
  end
end