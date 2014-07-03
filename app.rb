require 'sinatra'
require 'sinatra/activerecord'
require 'json'
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
    #params[user_id] = ...
  end

  get "/space/:space_id/messages" ,:auth => true do
  end

  post "/space/:space_id" ,:auth => true do
  end

  #What would do more RESTful?
  post "/space/join" ,:auth => true do
  end

  post "/space" ,:auth =>true do
  end
end
