require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require_relative 'models/spaces'
Dir["models/*.rb"].each {|file| require_relative file }

class Spacechat < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  def authorized?
    return true #for testing
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    #TODO certainly want to change this for your specific environment
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['admin', 'admin']
  end

  set(:auth) do |x|
    condition do
        redirect("/" , 303) if not authorized?
      end
  end

  get "/" do
    "Spacechat server ~~~>[o]>"
  end

  get "/user/:user_id/space/index" , :auth => true do
    id = params[:user_id]
    if User.exists?(id)
      User.find(id).spaces.to_json
    else
      status 404
    end
  end

  get "/user/:user_id/space/:space_id" ,:auth => true do
    id = params[:space_id]
    user_id = params[:user_id]
    if User.can_access_space?(user_id,space_id)
      Space.find(id).messages.to_json
    else
      status 404
    end
  end

  #post a message to a space
  post "/user/:user_id/space/:space_id" ,:auth => true do
    payload = JSON.parse(request.body.read)
    space_id, user_id = params[:space_id], params[:user_id]
    unless User.can_access_space?(user_id,space_id)
      status 403
      return
    end
    message = Message.new(payload)
    if messsage.save
      message.to_json
    else
      message.errors.messages.to_json
    end
  end

  post "/space/:space_id/join" ,:auth => true do
    payload = JSON.parse(request.body.read)
    unless payload.has_key? :invite_code
      status 404
      return
    end

    space_id = params[:space_id]
    if (Space.exists?({invite_code: payload[:invite_code], id:space_id}))

      #create a new user in the system if not exist
      unless User.exists? payload[:user_object][:id]
        new_user = User.new(payload[:user_object])
        unless new_user.save
          return new_user.errors.messages.to_json
        end
      end
      SpacesUser.new({user_id: payload[:user_object][:id],
                      space_id: id}).save
      Space.find(space_id).messages.to_json
    else
      status 403
    end
  end

  #Include user info so users can get into system when creating new space too!
  post "/space" ,:auth =>true do
    payload = JSON.parse(request.body.read)
    # TODO create a random invite code and return the whole created record to
    # the user
  end
end
