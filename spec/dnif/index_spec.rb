# encoding: utf-8
require 'test_helper'

class TestIndex < Test::Unit::TestCase

  test "field definition" do
    index = Dnif::Index.new(&proc { field :name })
    assert_equal [:name], index.fields
  end

  test "attribute definition" do
    index = Dnif::Index.new(&proc { attribute :another, :type => :bool })
    expected = { :another => :bool }
    assert_equal expected, index.attributes
  end

  test "where definition" do
    index = Dnif::Index.new(&proc { where "field = 'value'" })
    assert_equal "field = 'value'", index.conditions
  end
end