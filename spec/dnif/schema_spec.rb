# encoding: utf-8
require 'spec_helper'

describe Dnif::Schema do

  it ".generate" do
    schema = Dnif::Schema.new(User)
    expected = File.read(File.dirname(__FILE__) + "/../fixtures/sphinx_4.xml")
    schema.generate.should == expected
  end
end
