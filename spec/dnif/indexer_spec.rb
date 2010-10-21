# encoding: utf-8
require 'spec_helper'

describe Dnif::Indexer do

  describe ".define_index" do

    it ".define_index" do
      klass = Class.new
      klass.extend(Dnif::Indexer)
      klass.should_receive(:name).and_return("Klass")
      klass.define_index do
        field :a
        attribute :b, :type => :integer
        where "c"
      end

      klass.indexes["Klass"].fields.should == [ :a ]
      klass.indexes["Klass"].attributes.should == { :b => :integer }
      klass.indexes["Klass"].conditions.should == ["c"]

      klass.indexes.delete("Klass")
    end
  end

  it "should not include Index if there is no index definition inside the class" do
    Post.new.respond_to?(:to_sphinx).should be_false
    Post.respond_to?(:to_sphinx).should be_false
  end

  describe "#to_sphinx" do

    it "should return a sphinx document including defined fields" do
      comment = Person.create!(:first_name => "Rafael", :last_name => "Souza")

      expected = File.read(File.dirname(__FILE__) + "/../fixtures/sphinx_3.xml")
      comment.to_sphinx.should == expected
    end

    it "should return a sphinx document including defined attributes" do
      note = Note.create!(:id => 1, :title => "Note Title", :clicked => 10, :published_at => (now = DateTime.now), :expire_at => (expire = Date.today + 2.days), :active => true, :points => 1000)

      expected = File.read(File.dirname(__FILE__) + "/../fixtures/sphinx_2.xml")
      note.to_sphinx.should == expected.gsub("{now}", now.to_i.to_s).gsub("{expire}", expire.to_datetime.to_i.to_s)
    end
  end

  describe ".to_sphinx" do

    it "should generate a full sphinx xml" do
      comment = Person.create!(:first_name => "Rafael", :last_name => "Souza")

      expected = File.read(File.dirname(__FILE__) + "/../fixtures/sphinx_1.xml")
      Person.to_sphinx.should == expected.gsub("{comment}", comment.to_sphinx)
    end
  end

  describe ".indexes" do

    it "should return all indexed classes" do
      ActiveRecord::Base.indexes.keys.should == ["User", "Person", "Order", "Note"]
    end
  end
end
