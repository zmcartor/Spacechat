require_relative './test_helper'
require 'json'
class FunctionalTests < SpacechatTestHelper

  def test_hello_server
    get '/'
    assert last_response.ok?
    assert_equal "Spacechat server ~~~>[o]>", last_response.body
  end

  def test_no_auth_list_spaces
    get "/user/33/spaces"
    assert !last_response.ok?, "should not be allowed here"
  end

  def test_valid_user_list_spaces
    authorize_myself
    get "/user/33/spaces"
    assert last_response.ok?
    response_json = JSON.parse(last_response.body)
    assert response_json.count, 1
    assert response_json[0]['name'] == "Outer Space", "incorrect space name"
    assert response_json[0]['invite_code'] == 'beepbeep', "wrong invite code"
  end

  def test_invalid_user_list_spaces
    authorize_myself
    get "/user/900099/spaces"
    assert !last_response.ok?
  end

  def test_user_retrieve_messages_from_space
    authorize_myself
    get "/user/33/space/1"
    assert last_response.ok?
    response_json = JSON.parse(last_response.body)
    assert response_json.count, 1
    assert response_json[0]['text'] == "oh hello there!", "not right message"
  end

  def test_no_auth_retrive_messages_from_space
    get "/user/33/space/1"
    assert !last_response.ok?
  end

  def test_invalid_user_retrieve_messages_from_space
    authorize_myself
    get "/user/909000/space/1"
    assert !last_response.ok?
  end

  def test_user_retrieve_messsages_from_invalid_space
    authorize_myself
    get "/user/33/space/909090"
    assert !last_response.ok?
  end

  

end
