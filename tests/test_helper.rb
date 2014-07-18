ENV['RACK_ENV'] = 'test'
ENV['RAILS_ENV'] = 'test'

require 'minitest/autorun'
require "minitest/pride"
require 'rack/test'
require_relative '../app'
require_relative '../models/users'
require_relative '../models/spaces'
require 'database_cleaner'

User.connection
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

# setup our little environment in the DB.
# not using FactoryGirl because of complexity/headache
user = User.new({id: 33, name: "SpacemanSpiff"})
user.save
space = Space.new({name: "Outer Space", invite_code: "beepbeep", banner_url: "http://banner.com"})
space.save
user.spaces << space
user.save
Message.new({text:"oh hello there!", user_id:111, space_id:space.id }).save

class SpacechatTestHelper < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def setup
      header "Content-Type", "application/json"
  end

  def message_hash
    {text: "oh hi!", picture_url:"http://cool.com/pic.jpg"}
  end

  def join_space_hash
    {invite_code:"beepbeep", user: {id:44, name: "Mephisto"}}
  end

  def create_space_hash
    {space:{name: "Neat Space", banner_url:"http://neatbanner.com"}, user:{id: 12, name: "Neat Guy"}}
  end

  def authorize_myself
    pass = YAML.load_file('./config/pass.yml')['basic']
    authorize pass['user'], pass['pass']
  end

  def app
    Spacechat
  end
end
