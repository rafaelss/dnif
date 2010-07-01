# encoding: utf-8

$:.unshift(File.dirname(__FILE__) + "/../../lib/")
require 'test/unit'
require 'dnif'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
silence_stream(STDOUT) { load "fixtures/db/schema.rb" }

class User < ActiveRecord::Base
end

class Post < ActiveRecord::Base
end

class Comment < ActiveRecord::Base

  define_index do
    field :full_author
  end

  def full_author
    "full author name"
  end
end

class Sale < ActiveRecord::Base

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

class TestDnif < Test::Unit::TestCase

  test "objects without index should not have dnif included" do
    assert_false User.new.respond_to?(:to_sphinx)
  end

  test "to_sphinx returns a string with sphinx document" do
    Comment.create!(:author => "rafaelss")
    comment = Comment.first

    expected = "<sphinx:document id=\"7894\">\n  <full_author><![CDATA[[full author name]]></full_author>\n  <class_id>323,623,877,1133,1381,1646,1908</class_id>\n</sphinx:document>\n"
    assert_equal expected, comment.to_sphinx
  end

  test "attributes" do
    note = Note.create!(:clicked => 10, :published_at => (now = DateTime.now), :expire_at => (expire = Date.today + 2.days), :active => true, :points => 1000)

    expected = "<sphinx:document id=\"2969\">\n  <class_id>334,623,884,1125</class_id>\n  <clicked>10</clicked>\n  <published_at>#{now.to_i}</published_at>\n  <expire_at>#{expire.to_datetime.to_i}</expire_at>\n  <active>true</active>\n  <points>1000.0</points>\n</sphinx:document>\n"
    assert_equal expected, note.to_sphinx
  end

  test "an array of records should be transformed in a valid xml" do
    comment = Comment.create!(:author => "rafaelss")

    expected = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<sphinx:docset>\n<sphinx:schema>\n  <sphinx:field name=\"full_author\"/>\n  <sphinx:attr name=\"class_id\" type=\"multi\"/>\n</sphinx:schema>\n#{comment.to_sphinx}</sphinx:docset>"
    assert_equal expected, Comment.to_sphinx
  end
  
  test "return all indexed classes" do
    assert_equal ["Comment", "Sale", "Note"], ActiveRecord::Base.classes.keys
  end
  
  test ".root_path" do
    Dnif.root_path = File.dirname(__FILE__) + "/../fixtures"
    assert_equal File.dirname(__FILE__) + "/../fixtures", Dnif.root_path
  end

  test ".environment" do
    Dnif.environment = "test"
    assert_equal "test", Dnif.environment
  end

  test ".models_path" do
    Dnif.models_path = "./models"
    assert_equal "./models", Dnif.models_path
  end
end

# require 'active_record'
# 
# ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
# load "test/fixtures/db/schema.rb"
# 
# class A
# 
#   class << self
#     def test1
#       "test1"
#     end
# 
#     def test1_with_test2
#       puts "test2"
#       test1_without_test2
#     end
# 
#     alias_method_chain :test1, :test2
#   end
# end