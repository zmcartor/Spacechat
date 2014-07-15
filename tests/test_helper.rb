ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require "minitest/pride"
require 'rack/test'
require_relative '../app'

class SpacechatTestHelper < MiniTest::Unit::TestCase

  def app
    Spacechat
  end

  def setup
  end

  def teardown
  end

end
