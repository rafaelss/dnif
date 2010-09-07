# encoding: utf-8
require 'test_helper'

class TestDnif < Test::Unit::TestCase

  test ".root_path" do
    Dnif.root_path = "/root/path"
    assert_equal "/root/path", Dnif.root_path
  end

  test ".environment" do
    assert_equal "development", Dnif.environment
    Dnif.environment = "production"
    assert_equal "production", Dnif.environment
  end

  test ".models_path" do
    Dnif.models_path = "/models/path"
    assert_equal "/models/path", Dnif.models_path
  end
end