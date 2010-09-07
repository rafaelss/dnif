# encoding: utf-8
require 'spec_helper'

describe Dnif::MultiAttribute do

  it ".encode" do
    Dnif::MultiAttribute.encode("Dnif").should == "324,622,873,1126"
  end

  describe ".decode" do

    it "should decode a string" do
      Dnif::MultiAttribute.decode("324,622,873,1126").should == "Dnif"
    end

    it "should decode an array" do
      Dnif::MultiAttribute.decode(["324", "622", "873", "1126"]).should == "Dnif"
    end
  end
end
