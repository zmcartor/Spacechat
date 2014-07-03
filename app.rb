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

  get "/user/:user_id/spaces" , :auth => true do
    id = params[:user_id]
    if(User.exists?(id))
      User.find(id).spaces.to_json
    else
      status 404
    end
  end

  get "/space/:space_id" ,:auth => true do
    id = params[:space_id]
    if(Space.exists?(id))
      Space.find(id).messages.to_json
    else
      status 404
    end
  end

  post "/space/:space_id" ,:auth => true do
    payload = JSON.parse(request.body.read)
    id = params[:space_id]
    user_id = payload[:user_id]
    if(SpacesUser.exists?({:user_id => user_id, :space_id => id}))
      Message.new({user_id: user_id,
                  text: payload[:text],
                  picture_url: payload[:picture_url],
                  space_id: id}).save
    else
      status 403
    end
  end

  #What would do more RESTful?
  post "/space/:space_id/join" ,:auth => true do
    id = params[:space_id]
    payload = JSON.parse(request.body.read)
    if (Space.exists?({invite_code: payload[:invite_code], id:id}))
      SpacesUser.new({user_id: payload[:user_id],
                      space_id: id}).save
      Space.find(id).messages.to_json
    else
      status 403
    end
  end

  post "/space" ,:auth =>true do
    payload = JSON.parse(request.body.read)
    # TODO create a random invite code and return the whole created record to
    # the user
  end
end
