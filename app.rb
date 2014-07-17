require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require 'yaml'
require_relative 'models/spaces'
Dir["models/*.rb"].each {|file| require_relative file }

class Spacechat < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  def authorized?
    pass = YAML.load_file('./config/pass.yml')['basic']
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == [pass['user'], pass['pass']]
  end

  set(:auth) do |x|
    condition do
        throw :halt, [403, "Not Authorized"] if not authorized?
      end
  end

  get "/" do
    "Spacechat server ~~~>[o]>"
  end

  get "/user/:user_id/spaces" , :auth => true do
    puts request["Authorization"]
    user_id = params[:user_id].to_i
    if User.exists?(user_id)
      User.find(user_id).spaces.to_json
    else
      throw :halt,  [404, "User does not exist"]
    end
  end

  get "/user/:user_id/space/:space_id" ,:auth => true do
    space_id, user_id = params[:space_id].to_i, params[:user_id].to_i
    if User.can_access_space?(user_id,space_id)
      Space.find(space_id).messages.to_json
    else
      throw :halt, [404, "User cannot access space"]
    end
  end

  post "/user/:user_id/space/:space_id" ,:auth => true do
    payload = JSON.parse(request.body.read)
    space_id, user_id = params[:space_id].to_i, params[:user_id].to_i
    unless User.can_access_space?(user_id, space_id)
      throw :halt, [403, "User cannot access space"]
    end
    message = Message.new(payload)
    message.space_id, message.user_id = space_id, user_id
    unless message.save
      throw :halt, [400, message.errors.messages.to_json]
    end
    message.to_json
  end

  post "/space/join" ,:auth => true do
    payload = JSON.parse(request.body.read)
    unless payload.has_key? "invite_code"
        throw :halt, [404, "Missing invite code"]
    end
    if (Space.exists?({invite_code: payload["invite_code"]}))
      #create a new user in the system if not exist
      unless User.exists? payload["user"]["id"]
        new_user = User.new(payload["user"])
        unless new_user.save
          return new_user.errors.messages.to_json
        end
      end
      joined_space = Space.where({invite_code:payload["invite_code"]})[0]
      unless SpacesUser.exists?({user_id: payload["user"]["id"], space_id:joined_space.id})
        SpacesUser.new({user_id: payload["user"]["id"], space_id:joined_space.id}).save
      end
      joined_space.messages.to_json
    else
      throw :halt, [403, "Space does not exist"]
    end
  end

  delete "/user/:user_id/space/:space_id", :auth=>true do
    space_id, user_id = params[:space_id].to_i, params[:user_id].to_i
    if User.can_access_space?(user_id,space_id)
      SpacesUser.destroy_all({user_id: user_id, space_id:space_id})
      status 200
    else
      throw :halt, [404, "User cannot access space"]
    end
  end

  post "/space" ,:auth =>true do
    payload = JSON.parse(request.body.read)
    unless payload["user"]["id"]
      throw :halt, [400, "Missing user id"]
    end
    user_id = payload["user"]["id"]
    #create a new user in the system if not exist
    unless User.exists? user_id
      new_user = User.new(payload["user"])
      unless new_user.save
        return new_user.errors.messages.to_json
      end
    end
    payload["space"]["invite_code"] = Space.create_invite_code
    new_space = Space.new(payload["space"])
    unless new_space.save
      throw :halt, [400, new_space.errors.messages.to_json]
    end
    user = User.find(user_id)
    user.spaces << new_space
    unless user.save
      throw :halt [400, "Could not save space"]
    end
    new_space.to_json
  end

end
