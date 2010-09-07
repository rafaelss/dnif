# encoding: utf-8
require 'spec_helper'
require 'erb'

describe Dnif::Configuration do

  it "should generate configuration from default template" do
    File.should_receive(:read).with("config/path.erb").and_return("configurations")

    template = mock("Template")
    template.should_receive(:result).and_return('output')
    ERB.should_receive(:new).with("configurations").and_return(template)

    file = mock
    file.should_receive(:puts).with('output')
    File.should_receive(:open).with(Dnif.root_path + "/config/sphinx/development.conf", "w").and_yield(file)

    path = Dnif::Configuration.generate("config/path.erb")
    path.should == File.join(Dnif.root_path, "config", "sphinx", "development.conf")
  end

  describe "helpers" do

    it "should iterate over all indexed classes" do
      names = []
      classes = []
      Dnif::Configuration.sources do |name, class_name|
        names << name
        classes << class_name
      end

      names.should == ["users_main", "people_main", "orders_main", "notes_main"]
      classes.should == ["User", "Person", "Order", "Note"]
    end
  end

  it ".options_for" do
    client = Dnif::Configuration.options_for("searchd", File.join(Dnif.root_path, "templates", "config.erb"))
    client.should be_kind_of(Hash)
  end
end
