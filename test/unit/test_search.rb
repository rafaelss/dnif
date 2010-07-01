# encoding: utf-8

$:.unshift(File.dirname(__FILE__) + "/../../lib/")
require 'test/unit'
require 'dnif'
require 'mocha'

class Post

  extend Dnif::Search
end

class Comment

  extend Dnif::Search
end

class TestSearch < Test::Unit::TestCase

  test "search" do
    results_for_post = {
      :matches => [{
        :doc => 2984,
        :attributes => {
          "class_id" => "336,623,883,1140"
        }
      }]
    }
    results_for_comment = {
      :matches => [{
        :doc => 7895,
        :attributes => {
          "class_id" => "323,623,877,1133,1381,1646,1908"
        }
      }]
    }

    Riddle::Client.any_instance.expects(:query).times(2).with("post", "*").returns(results_for_post, results_for_comment)
    ActiveRecord::Base.expects(:classes).times(2).returns({"Post" => mock, "Comment" => mock})

    Post.expects(:find_all_by_id).once.with([1090])
    Comment.expects(:find_all_by_id).once.with([3167])

    Post.search("post")
    Comment.search("post")
  end
end