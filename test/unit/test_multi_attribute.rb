# encoding: utf-8
require 'test_helper'

class TestMultiAttribute < Test::Unit::TestCase
  
  test ".encode" do
    assert_equal "324,622,873,1126", Dnif::MultiAttribute.encode("Dnif")
  end

  test ".decode" do
    assert_equal "Dnif", Dnif::MultiAttribute.decode("324,622,873,1126")
  end

  test ".decode as array" do
    assert_equal "Dnif", Dnif::MultiAttribute.decode(["324", "622", "873", "1126"])
  end
end