# encoding: utf-8
require 'spec_helper'

describe Dnif::Index do

  it "should define a field" do
    index = Dnif::Index.new(&proc { field :name })
    index.fields.should == [ :name ]
  end

  it "should define an attribute" do
    index = Dnif::Index.new(&proc { attribute :another, :type => :bool })
    index.attributes.should == { :another => :bool }
  end

  it "should define where clause" do
    index = Dnif::Index.new(&proc { where "field = 'value'" })
    index.conditions.should == ["field = 'value'"]
  end
end
