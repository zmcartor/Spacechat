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
    self.authorize_myself
    get "/user/33/spaces"
    assert last_response.ok?
    response_json = JSON.parse(last_response.body)
    assert response_json.count, 1
    assert response_json[0]['name'] == "Outer Space", "incorrect space name"
    assert response_json[0]['invite_code'] == 'beepbeep', "wrong invite code"
  end

  def test_invalid_user_list_spaces
    self.authorize_myself
    get "/user/900099/spaces"
    assert !last_response.ok?
  end

  def test_user_retrieve_messages_from_space
    self.authorize_myself
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
    self.authorize_myself
    get "/user/909000/space/1"
    assert !last_response.ok?
  end

  def test_user_retrieve_messsages_from_invalid_space
    self.authorize_myself
    get "/user/33/space/909090"
    assert !last_response.ok?
  end

  def test_post_to_space_no_auth
    post "/user/33/space/1", self.message_hash().to_json
    assert !last_response.ok?
  end

  def test_post_to_space_user_not_allowed
    self.authorize_myself
    post "/user/34343/space/1", self.message_hash().to_json
    assert !last_response.ok?
  end

  def test_post_to_space
    self.authorize_myself
    post "/user/33/space/1", self.message_hash().to_json
    assert last_response.ok?
    response_json = JSON.parse(last_response.body)
    assert response_json['text'] == 'oh hi!', "message json not returned"
  end

  def test_no_auth_join_space
    post "/space/join", self.join_space_hash().to_json
    assert !last_response.ok?
  end

  def test_join_space_invalid_invite_code
    self.authorize_myself
    post_hash = self.join_space_hash
    post_hash['invite_code'] = "badInviteCode"
    post "/space/join", post_hash.to_json
    assert !last_response.ok?
  end

  def test_join_space_creates_user_record
    self.authorize_myself
    post "/space/join", self.join_space_hash().to_json
    assert last_response.ok?
    assert User.exists?(44), "new user not created"
    assert User.find(44).spaces.count ==1 , "space not associated with user"
  end

  def test_no_auth_leave_space
    delete "/user/33/space/1"
    assert !last_response.ok?
  end

  def test_user_leave_space_not_member
    self.authorize_myself
    delete "/user/23232/space/1"
    assert !last_response.ok?
  end

  def test_user_leave_space_not_exist
    self.authorize_myself
    delete "/user/33/space/1219191"
    assert !last_response.ok?
  end

  def test_user_leave_space
    user = User.new({id: 99, name: "TDD Man"})
    user.save
    user.spaces << Space.find(1)
    user.save

    self.authorize_myself
    delete "/user/99/space/1"
    assert last_response.ok?, "could not leave space"
  end

  def test_user_create_space_no_auth
    post "/space", self.create_space_hash().to_json
    assert !last_response.ok?
  end

  def test_user_create_space_user_record_created
    self.authorize_myself
    post_hash = self.create_space_hash
    post_hash[:user][:id] = 55

    post "/space", post_hash.to_json

    assert last_response.ok?
    assert User.exists?(55)
  end

  def test_user_create_user
    self.authorize_myself
    post "/space", self.create_space_hash().to_json

    json_response = JSON.parse(last_response.body)
    assert last_response.ok?
    assert json_response['name'] == 'Neat Space', 'not the right space'
    assert json_response.key?("invite_code") , 'no invite code'

  end

  def test_user_create_space_association
    self.authorize_myself
    post "/space", self.create_space_hash().to_json

    user = User.find(12)
    json_response = JSON.parse(last_response.body)

    assert last_response.ok?
    assert user.spaces[0]['name'] == 'Neat Space', "user not joined to space"
  end

end
