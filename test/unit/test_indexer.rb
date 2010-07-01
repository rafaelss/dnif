# encoding: utf-8
require 'test_helper'

class TestIndexer < Test::Unit::TestCase

  test "objects without index should not have dnif included" do
    assert_false Post.new.respond_to?(:to_sphinx)
    assert_false Post.respond_to?(:to_sphinx)
  end

  test "to_sphinx returns a string with sphinx document" do
    comment = Person.create!(:first_name => "Rafael", :last_name => "Souza")

    expected = "<sphinx:document id=\"6009\">\n  <full_name><![CDATA[[Rafael Souza]]></full_name>\n  <class_id>336,613,882,1139,1391,1646</class_id>\n</sphinx:document>\n"
    assert_equal expected, comment.to_sphinx
  end

  test "attributes" do
    note = Note.create!(:clicked => 10, :published_at => (now = DateTime.now), :expire_at => (expire = Date.today + 2.days), :active => true, :points => 1000)

    expected = "<sphinx:document id=\"2967\">\n  <class_id>334,623,884,1125</class_id>\n  <clicked>10</clicked>\n  <published_at>#{now.to_i}</published_at>\n  <expire_at>#{expire.to_datetime.to_i}</expire_at>\n  <active>true</active>\n  <points>1000.0</points>\n</sphinx:document>\n"
    assert_equal expected, note.to_sphinx
  end

  test ".to_sphinx should generate a full sphinx xml" do
    comment = Person.create!(:first_name => "Rafael", :last_name => "Souza")

    expected = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<sphinx:docset>\n<sphinx:schema>\n  <sphinx:field name=\"full_name\"/>\n  <sphinx:attr name=\"class_id\" type=\"multi\"/>\n</sphinx:schema>\n#{comment.to_sphinx}</sphinx:docset>"
    assert_equal expected, Person.to_sphinx
  end
  
  test "return all indexed classes" do
    assert_equal ["User", "Person", "Order", "Note"], ActiveRecord::Base.classes.keys
  end
end