# encoding: utf-8
require 'spec_helper'

describe Dnif::Search do

  describe ".config_path" do

    it "should return '.' when not specified" do
      File.should_receive(:expand_path).and_return("/expanded/path")
      Dnif.should_receive(:root_path).twice.and_return(nil, ".")
      Dnif.should_receive(:root_path=).with("/expanded/path")
      Dnif.should_receive(:environment).and_return("development")

      Dnif.config_path.should == "./config/sphinx/development.erb"
    end

    it "should return specified root_path" do
      Dnif.should_receive(:root_path).twice.and_return("/root/path", "/root/path")
      Dnif.should_receive(:environment).and_return("development")

      Dnif.config_path.should == "/root/path/config/sphinx/development.erb"
    end
  end

  describe ".client" do

    it "should understand 'listen' sphinx setting" do
      Dnif.should_receive(:config_path).and_return("config/path.erb")
      Dnif::Configuration.should_receive(:options_for).with("searchd", "config/path.erb").and_return({ "listen" => "127.0.0.1:3313" })
      Riddle::Client.should_receive(:new).with("127.0.0.1", "3313")

      Dnif.client
    end

    it "should understand 'address' and 'port' sphinx setting" do
      Dnif.should_receive(:config_path).and_return("config/path.erb")
      Dnif::Configuration.should_receive(:options_for).with("searchd", "config/path.erb").and_return({ "address" => "127.0.0.1", "port" => "3313" })
      Riddle::Client.should_receive(:new).with("127.0.0.1", "3313")

      Dnif.client
    end
  end

  describe ".search" do

    it "should search for all models" do
      results = {
        :matches => [{
                       :doc => 2983,
                       :attributes => {
                         "class_name" => "336,623,883,1140"
                       }
                     }, {
                       :doc => 7893,
                       :attributes => {
                         "class_name" => "323,623,877,1133,1381,1646,1908"
                       }
        }]
      }

      riddle = mock("Riddle")
      riddle.should_receive(:query).with("my search", "*").and_return(results)
      Dnif.should_receive(:client).and_return(riddle)
      Post.should_receive(:find_all_by_id).once.with([1])
      Comment.should_receive(:find_all_by_id).once.with([2])

      Dnif.search("my search")
    end

    it "should search specific models" do
      riddle = mock("Riddle")
      riddle.should_receive(:query).with("post", "*").and_return(results_for_post)
      riddle.should_receive(:query).with("comment", "*").and_return(results_for_comment)
      riddle.should_receive(:filters=).twice.and_return([])
      Dnif.should_receive(:client).exactly(4).times.and_return(riddle)

      ActiveRecord::Base.should_receive(:indexes).twice.and_return({ "Post" => mock, "Comment" => mock })

      Riddle::Client::Filter.should_receive(:new).with("class_id", [0])
      Riddle::Client::Filter.should_receive(:new).with("class_id", [1])

      Post.should_receive(:find_all_by_id).once.with([1])
      Comment.should_receive(:find_all_by_id).once.with([2])

      Post.search("post")
      Comment.search("comment")
    end

    it "should search only specified models" do
      riddle = mock("Riddle")
      riddle.should_receive(:query).with("post", "*").and_return(results_for_post)
      riddle.should_receive(:filters=).and_return([])
      Dnif.should_receive(:client).exactly(2).times.and_return(riddle)

      ActiveRecord::Base.should_receive(:indexes).and_return({ "Post" => mock })

      Riddle::Client::Filter.should_receive(:new).with("class_id", [0])
      Post.should_receive(:find_all_by_id).once.with([1])

      Dnif.search("post", :classes => "Post")
    end
  end

  private
    def results_for_post
      {
        :matches => [{
                       :doc => 2983,
                       :attributes => {
                         "class_name" => "336,623,883,1140"
                       }
        }]
      }
    end

    def results_for_comment
      {
        :matches => [{
                       :doc => 7893,
                       :attributes => {
                         "class_name" => "323,623,877,1133,1381,1646,1908"
                       }
        }]
      }
    end
end
