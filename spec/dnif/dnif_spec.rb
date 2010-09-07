# encoding: utf-8
require 'spec_helper'

describe Dnif do

  after(:each) do
    Dnif.instance_variable_set(:"@root_path", nil)
    Dnif.instance_variable_set(:"@environment", nil)
    Dnif.instance_variable_set(:"@models_path", nil)
  end

  it ".root_path" do
    Dnif.root_path = "/root/path"
    Dnif.root_path.should == "/root/path"
  end

  it ".environment" do
    Dnif.environment.should == "development"

    Dnif.environment = "production"
    Dnif.environment.should == "production"
  end

  it "should have .environment aliased by .env" do
    Dnif.env.should == "development"

    Dnif.env = "production"
    Dnif.env.should == "production"
  end

  it ".models_path" do
    Dnif.models_path = "/models/path"
    Dnif.models_path.should == "/models/path"
  end
end
