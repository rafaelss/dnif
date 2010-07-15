# encoding: utf-8
require 'test_helper'

class TestIndexer < Test::Unit::TestCase

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  test ".define_index" do
    klass = Class.new
    klass.extend(Dnif::Indexer)
    klass.stubs(:name).returns("Klass")
    klass.define_index do
      field :a
      attribute :b, :type => :integer
      where "c"
    end

    assert_equal [:a], klass.indexes["Klass"].fields
    assert_equal({ :b => :integer }, klass.indexes["Klass"].attributes)
    assert_equal "c", klass.indexes["Klass"].conditions

    klass.indexes.delete("Klass")
  end

  test "objects without index should not have dnif included" do
    assert_false Post.new.respond_to?(:to_sphinx)
    assert_false Post.respond_to?(:to_sphinx)
  end

  test "to_sphinx returns a string with sphinx document" do
    comment = Person.create!(:first_name => "Rafael", :last_name => "Souza")

    expected = File.read(File.dirname(__FILE__) + "/../fixtures/sphinx_3.xml")
    assert_equal expected, comment.to_sphinx
  end

  test "attributes" do
    note = Note.create!(:title => "Note Title", :clicked => 10, :published_at => (now = DateTime.now), :expire_at => (expire = Date.today + 2.days), :active => true, :points => 1000)

    expected = File.read(File.dirname(__FILE__) + "/../fixtures/sphinx_2.xml")
    assert_equal expected.gsub("{now}", now.to_i.to_s).gsub("{expire}", expire.to_datetime.to_i.to_s), note.to_sphinx
  end

  test ".to_sphinx should generate a full sphinx xml" do
    comment = Person.create!(:first_name => "Rafael", :last_name => "Souza")

    expected = File.read(File.dirname(__FILE__) + "/../fixtures/sphinx_1.xml")
    assert_equal expected.gsub("{comment}", comment.to_sphinx), Person.to_sphinx
  end

  test "return all indexed classes" do
    assert_equal ["User", "Person", "Order", "Note"], ActiveRecord::Base.indexes.keys
  end
end