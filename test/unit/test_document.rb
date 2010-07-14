# encoding: utf-8
require 'test_helper'

class TestDocument < Test::Unit::TestCase

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  test ".generate" do
    Dnif::MultiAttribute.expects(:encode).with("User").returns("1,2,3,4")

    user = User.create!(:name => "Rafael Souza", :active => true)

    document = Dnif::Document.new(user)
    expected = File.read(File.dirname(__FILE__) + "/../fixtures/sphinx_5.xml")
    assert_equal expected, document.generate
  end

  test "convertion of date/datetime values to timestamp" do
    now = DateTime.now
    now.expects(:to_i)
    expire = Date.today + 2.days
    expire.expects(:to_i)
    expire.expects(:to_datetime).returns(expire)

    note = Note.create!(
      :title => "Note Title",
      :clicked => 10,
      :published_at => now,
      :expire_at => expire,
      :active => true,
      :points => 1000
    )
    note.to_sphinx
  end
end