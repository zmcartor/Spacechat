require_relative './test_helper'

class GoodInputTest < SpacechatTestHelper
  include Rack::Test::Methods

  def headers
    #return needed headers and HTTP-basicAuth stuff !!
  end


  def test_hello_server
    get '/'
    assert last_response.ok?
    assert_equal "Spacechat server ~~~>[o]>", last_response.body
  end

  #get "/user/:user_id/space/:space_id
  def test_user_list_spaces
    u = User.find(33)
    puts "name is: #{u.name}"
    post '', {:bar => "baz"}.to_json, "CONTENT_TYPE" => "application/json"
    # validate response here
  end

  #post "/user/:user_id/space/:space_id"
  def test_user_post_to_space

  end

  #post "/space/join"
  def test_join_space

  end

end
