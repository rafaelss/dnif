# encoding: utf-8
require 'spec_helper'

describe Dnif::Document do

  describe "#generate" do

    it "should generate a single document" do
      Dnif::MultiAttribute.should_receive(:encode).with("User").and_return("1,2,3,4")

      user = User.create!(:name => "Rafael Souza", :active => true, :weight => 34.5)

      document = Dnif::Document.new(user)
      expected = File.read(File.dirname(__FILE__) + "/../fixtures/sphinx_5.xml")
      document.generate.should == expected
    end
  end

  describe "#document_id" do

    it "should calculate document id for sphinx" do
      user = User.create!(:name => "Rafael Souza", :active => true)

      document = Dnif::Document.new(user)
      document.document_id.should == user.id + [ 341, 627, 869, 1138].sum
    end
  end

  it "should convert date/datetime values to timestamp" do
    now = DateTime.now
    now.should_receive(:to_i)
    expire = Date.today + 2.days
    expire.should_receive(:to_i)
    expire.should_receive(:to_datetime).and_return(expire)

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
