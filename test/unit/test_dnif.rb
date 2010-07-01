# encoding: utf-8

$:.unshift(File.dirname(__FILE__) + "/../../lib/")
require 'test/unit'
require 'dnif'

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

  test "use RAILS_ROOT if using Rails" do
    ::Rails = Class
    ::RAILS_ROOT = "/rails/root"
    ::RAILS_ENV = "development"

    Object.send(:remove_const, :Dnif)
    load 'dnif.rb'

    assert_equal "/rails/root", Dnif.root_path
    assert_equal "development", Dnif.environment
    assert_equal "/rails/root/app/models", Dnif.models_path
  end
end