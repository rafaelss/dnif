# encoding: utf-8
require 'test_helper'

class TestSearch < Test::Unit::TestCase

  test ".config_path with nil root_path" do
    File.expects(:expand_path).returns("/expanded/path")
    Dnif.expects(:root_path).twice.returns(nil, ".")
    Dnif.expects(:root_path=).with("/expanded/path")
    Dnif.expects(:environment).returns("development")

    assert_equal "./config/sphinx/development.erb", Dnif.config_path
  end

  test ".config_path with defined root_path" do
    Dnif.expects(:root_path).twice.returns("/root/path", "/root/path")
    Dnif.expects(:environment).returns("development")

    assert_equal "/root/path/config/sphinx/development.erb", Dnif.config_path
  end

  test ".client when config uses listen" do
    Dnif.expects(:config_path).returns("config/path.erb")
    Dnif::Configuration.expects(:options_for).with("searchd", "config/path.erb").returns({ "listen" => "127.0.0.1:3313" })
    Riddle::Client.expects(:new).with("127.0.0.1", "3313")

    Dnif.client
  end

  test ".client when config uses address and port" do
    Dnif.expects(:config_path).returns("config/path.erb")
    Dnif::Configuration.expects(:options_for).with("searchd", "config/path.erb").returns({ "address" => "127.0.0.1", "port" => "3313" })
    Riddle::Client.expects(:new).with("127.0.0.1", "3313")

    Dnif.client
  end

  test ".search" do
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
    riddle.expects(:query).with("my search", "*").returns(results)
    Dnif.expects(:client).returns(riddle)
    Post.expects(:find_all_by_id).once.with([1])
    Comment.expects(:find_all_by_id).once.with([2])

    Dnif.search("my search")
  end

  test ".search through models" do
    riddle = mock("Riddle")
    riddle.expects(:query).with("post", "*").returns(results_for_post)
    riddle.expects(:query).with("comment", "*").returns(results_for_comment)
    riddle.expects(:filters=).twice.returns([])
    Dnif.expects(:client).times(4).returns(riddle)

    ActiveRecord::Base.expects(:indexes).twice.returns({ "Post" => mock, "Comment" => mock })

    Riddle::Client::Filter.expects(:new).with("class_id", [0])
    Riddle::Client::Filter.expects(:new).with("class_id", [1])

    Post.expects(:find_all_by_id).once.with([1])
    Comment.expects(:find_all_by_id).once.with([2])

    Post.search("post")
    Comment.search("comment")
  end

  test "search only in specified models" do
    riddle = mock("Riddle")
    riddle.expects(:query).with("post", "*").returns(results_for_post)
    riddle.expects(:filters=).returns([])
    Dnif.expects(:client).times(2).returns(riddle)

    ActiveRecord::Base.expects(:indexes).returns({ "Post" => mock })

    Riddle::Client::Filter.expects(:new).with("class_id", [0])
    Post.expects(:find_all_by_id).once.with([1])

    Dnif.search("post", :classes => "Post")
  end

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