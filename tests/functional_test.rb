require_relative './test_helper'
class GoodInputTest < SpacechatTestHelper

  def test_hello_server
    get '/'
    assert last_response.ok?
    assert_equal "Spacechat server ~~~>[o]>", last_response.body
  end


  def test_user_list_spaces
    get "/user/33/spaces"
    puts last_response.body
    # validate response here
  end

end
