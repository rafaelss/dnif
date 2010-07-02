# encoding: utf-8
require 'test_helper'

class TestSearch < Test::Unit::TestCase

  test "search" do
    results_for_post = {
      :matches => [{
        :doc => 2983,
        :attributes => {
          "class_id" => "336,623,883,1140"
        }
      }]
    }
    results_for_comment = {
      :matches => [{
        :doc => 7893,
        :attributes => {
          "class_id" => "323,623,877,1133,1381,1646,1908"
        }
      }]
    }

    Dnif::Configuration.expects(:options_for).twice.returns({ "listen" => "127.0.0.1:3333" })
    Riddle::Client.any_instance.expects(:query).twice.with("post", "*").returns(results_for_post, results_for_comment)

    Post.expects(:find_all_by_id).once.with([1])
    Comment.expects(:find_all_by_id).once.with([2])

    Post.search("post")
    Comment.search("post")
  end
end