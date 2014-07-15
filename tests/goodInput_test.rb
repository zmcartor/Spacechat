require_relative './test_helper'

class GoodInputTest < SpacechatTestHelper
  include Rack::Test::Methods

  def test_hello_world
    get '/'
    assert last_response.ok?
    assert_equal "Spacechat server ~~~>[o]>", last_response.body
  end

  #get "/user/:user_id/space/:space_id
  def test_user_list_spaces
    post '', {:bar => "baz"}.to_json, "CONTENT_TYPE" => "application/json"
    # validate response here
  end

  #post "/user/:user_id/space/:space_id"
  def test_user_post_to_space

  end


end
