# encoding: utf-8
require 'spec_helper'

describe Dnif::Search do

  describe "#search" do

    it "should search specific class" do
      klass = Class.new
      klass.extend(Dnif::Search)
      klass.should_receive(:name).and_return("ClassName")

      Dnif.should_receive(:search).with("foo", :classes => "ClassName").and_return("results")

      klass.search("foo").should == "results"
    end
  end
end
